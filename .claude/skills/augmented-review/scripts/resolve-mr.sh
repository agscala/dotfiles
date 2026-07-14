#!/usr/bin/env bash
# ABOUTME: Resolves a GitLab MR URL or !IID into project_id and mr_iid.
# ABOUTME: Read-only — only calls GET endpoints via glab api.
# Usage: resolve-mr.sh <mr-url-or-iid>
# Output: JSON with project_id, mr_iid, title, description, author, web_url, state

set -euo pipefail

INPUT="${1:?Usage: resolve-mr.sh <mr-url-or-iid>}"

for cmd in glab jq; do
  if ! command -v "$cmd" &>/dev/null; then
    echo "ERROR: $cmd is required but not installed." >&2
    exit 1
  fi
done

api_get() {
  local endpoint="$1"
  local attempts=0
  local max_attempts=3
  local delay=1

  while (( attempts < max_attempts )); do
    if glab api "$endpoint" 2>/dev/null; then
      return 0
    fi
    attempts=$((attempts + 1))
    if (( attempts >= max_attempts )); then
      return 1
    fi
    sleep "$delay"
    delay=$((delay * 2))
  done
  return 1
}

# Parse input: URL or !IID
if [[ "$INPUT" =~ merge_requests/([0-9]+) ]]; then
  MR_IID="${BASH_REMATCH[1]}"
  # Extract project path from URL: https://gitlab.com/group/project/-/merge_requests/123
  PROJECT_PATH=$(echo "$INPUT" | sed -E 's|https?://[^/]+/||; s|/-/merge_requests/[0-9]+.*||')
  ENCODED_PATH=$(echo "$PROJECT_PATH" | sed 's|/|%2F|g')
elif [[ "$INPUT" =~ ^!?([0-9]+)$ ]]; then
  MR_IID="${BASH_REMATCH[1]}"
  # Use current repo context
  REMOTE_URL=$(git remote get-url origin 2>/dev/null || true)
  if [[ -z "$REMOTE_URL" ]]; then
    echo "ERROR: No MR URL provided and not in a git repo." >&2
    exit 1
  fi
  PROJECT_PATH=$(echo "$REMOTE_URL" | sed -E 's|.*[:/]([^:]+)\.git$|\1|; s|.*[:/]([^:]+)$|\1|')
  ENCODED_PATH=$(echo "$PROJECT_PATH" | sed 's|/|%2F|g')
else
  echo "ERROR: Could not parse MR reference: $INPUT" >&2
  echo "Expected: GitLab MR URL or !IID" >&2
  exit 1
fi

MR_JSON=$(api_get "projects/${ENCODED_PATH}/merge_requests/${MR_IID}")

echo "$MR_JSON" | jq '{
  project_id: .project_id,
  mr_iid: .iid,
  title: .title,
  description: .description,
  author: .author.username,
  web_url: .web_url,
  state: .state,
  source_branch: .source_branch,
  target_branch: .target_branch,
  labels: .labels,
  draft: .draft
}'
