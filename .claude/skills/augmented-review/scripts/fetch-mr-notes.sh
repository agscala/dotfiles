#!/usr/bin/env bash
# ABOUTME: Fetches discussion notes for a single GitLab merge request.
# ABOUTME: Read-only — only calls GET endpoints via glab api.
# Usage: fetch-mr-notes.sh <project-id> <mr-iid>

set -euo pipefail

PROJECT_ID="${1:?Usage: fetch-mr-notes.sh <project-id> <mr-iid>}"
MR_IID="${2:?Usage: fetch-mr-notes.sh <project-id> <mr-iid>}"

if ! [[ "$PROJECT_ID" =~ ^[0-9]+$ ]]; then
  echo "ERROR: project-id must be numeric, got: $PROJECT_ID" >&2
  exit 1
fi
if ! [[ "$MR_IID" =~ ^[0-9]+$ ]]; then
  echo "ERROR: mr-iid must be numeric, got: $MR_IID" >&2
  exit 1
fi

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
    if glab api "$endpoint" --paginate 2>/dev/null; then
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

discussions=$(api_get "projects/${PROJECT_ID}/merge_requests/${MR_IID}/discussions?per_page=100" || echo "[]")

# Check if the response is an API error (single JSON object instead of array)
if echo "$discussions" | jq -e 'type == "object" and has("message")' &>/dev/null; then
  error_msg=$(echo "$discussions" | jq -r '.message // "unknown error"')
  echo "WARNING: GitLab API error: ${error_msg}" >&2
fi

# Flatten discussions into individual notes with thread context
# Use -s to slurp paginated output (multiple JSON arrays) into one array
# Filter out any error objects (non-arrays) that may appear in paginated output
echo "$discussions" | jq -sc '
  [.[] | select(type == "array")] | (add // []) | [.[] | {
    discussion_id: .id,
    notes: [.notes[] | select(.system == false) | {
      id: .id,
      author: .author.username,
      body: .body,
      file: .position.new_path,
      old_file: .position.old_path,
      line: .position.new_line,
      old_line: .position.old_line,
      resolved: .resolved,
      resolvable: .resolvable,
      created_at: .created_at
    }]
  } | select(.notes | length > 0)]
'
