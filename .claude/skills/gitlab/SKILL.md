---
name: gitlab
description: Comprehensive GitLab operations using the glab CLI. Handles MRs, issues, pipelines, projects, and more. Use for any GitLab interaction.
metadata:
  tags:
    - git
  status: recommended
allowed-tools: Bash(glab *), Bash(git status:*), Bash(git diff:*), Bash(git log:*), Bash(git branch:*), Bash(git rev-parse:*), Bash(git fetch:*), AskUserQuestion, mcp__zapier__jira_software_cloud_find_issue_by_key
---

# GitLab Operations

Comprehensive GitLab operations using the `glab` CLI exclusively. This skill covers MRs, issues, pipelines, projects, and all GitLab interactions.

## When to Use This Skill

Activate this skill when:
- The user wants to create, view, or update a merge request
- The user says "create MR", "open MR", "my MRs", "merge request"
- The user wants to check pipeline status or CI/CD
- The user says "check pipeline", "ci status", "retry pipeline"
- The user wants to create or view GitLab issues
- The user mentions "gitlab", "glab", or any GitLab operation
- The user says "redux" for a ticket (follow-up MR)
- The user asks about project details or repository info

## Core Principle: Always Use glab

**NEVER use curl, the GitLab API directly, or MCP GitLab tools.** Always use the `glab` CLI for all GitLab operations. This ensures:
- Consistent authentication
- Proper error handling
- Familiar command patterns

---

# Part 1: Merge Requests

## Philosophy: Storytelling for Humans

MR descriptions are **not** changelogs or git logs. They're narratives that help reviewers understand:

1. **WHY** - The motivation, problem, or user need driving this change
2. **WHAT** - The solution approach and key decisions made
3. **HOW** - How to review, test, and verify the changes

Write for a human who:
- Wasn't in the room when decisions were made
- Needs to review this efficiently
- Might revisit this MR in 6 months during debugging

## Creating a New MR

### 1. Gather Context

> **NEVER hardcode `main` as the target branch.** Always resolve the repo's default
> branch dynamically before creating the MR. Different repos use different default
> branches (e.g., `staging`, `develop`, `main`).

```bash
# Determine the repo's default branch
DEFAULT_BRANCH=$(git remote show origin | awk '/HEAD branch/ {print $NF}')

# Current branch and remote status
git branch --show-current

# What's different from the target branch
git log "origin/$DEFAULT_BRANCH"..HEAD --oneline
git diff "origin/$DEFAULT_BRANCH" --stat

# Recent commit messages for context
git log --oneline -10
```

### 2. Extract Jira Context (if applicable)

Parse the branch name for Jira ticket patterns:
- `PROJ-123-feature-name`
- `feature/PROJ-123-description`

If found, use `mcp__zapier__jira_software_cloud_find_issue_by_key` to fetch:
- Ticket title and description
- Acceptance criteria
- Related context

### 3. Ask the Human for Context

**ALWAYS use AskUserQuestion to understand the "why".**

Based on the diff and any Jira context, generate 3-4 specific options:

```
Question: "What's the main goal of this MR?"
Options:
- "Fix bug where users couldn't X"
- "Add new capability for Y"
- "Improve performance of Z"
- "Refactor to prepare for upcoming W"
```

### 4. Craft the Description

Structure the description as a story:

```markdown
## Why

[1-3 sentences explaining the motivation. What problem exists? Who is affected?
Link to Jira ticket if applicable.]

## What

[Describe the solution approach. What key decisions were made and why?
This is not a list of files changed - it's the strategy.]

### Key Changes
- [Meaningful change 1 - what it does, not just what file]
- [Meaningful change 2]
- [Meaningful change 3]

## How to Review

[Guide the reviewer. What should they focus on? What's the critical path?]

1. Start with `path/to/important/file.ts` - this is the core logic
2. Then review the tests in `path/to/tests/`
3. The other files are just plumbing

## How to Test

[Concrete steps to verify this works]

1. Step one
2. Step two
3. Expected result

## Notes

[Optional: anything else - risks, follow-up work, dependencies, screenshots]
```

### 5. Create the MR

**All MRs are created as drafts by default.**

```bash
# Resolve the default branch (NEVER hardcode main)
DEFAULT_BRANCH=$(git remote show origin | awk '/HEAD branch/ {print $NF}')

# Create MR with glab - ALWAYS prepend Jira ticket ID to title
glab mr create \
  --draft \
  --squash-before-merge \
  --remove-source-branch \
  --title "PROJ-123: Concise description of the change" \
  --description "$(cat <<'EOF'
## Why

[description content here]

## What

[description content here]

## How to Review

[description content here]

## How to Test

[description content here]
EOF
)" \
  --target-branch "$DEFAULT_BRANCH" \
  --assignee @me
```

## Redux (Follow-up MR for Same Ticket)

When the user says "redux" for a Jira ticket (e.g., "redux PROJ-123"):

```bash
# Find existing branches for the ticket
git fetch --all
git branch -r | grep -i "PROJ-123"

# Create redux branch (append -redux to original)
DEFAULT_BRANCH=$(git remote show origin | awk '/HEAD branch/ {print $NF}')
git checkout "$DEFAULT_BRANCH" && git pull origin "$DEFAULT_BRANCH"
git checkout -b PROJ-123-fix-something-redux

# If -redux exists, use -redux-2, -redux-3, etc.
```

## Updating an Existing MR

```bash
# List your open MRs
glab mr list --author=@me

# View current MR (if on the branch)
glab mr view

# Update description
glab mr update 123 --description "$(cat <<'EOF'
[new description]
EOF
)"

# Update title
glab mr update 123 --title "new title"

# Add reviewers
glab mr update 123 --reviewer user1,user2

# Mark ready for review (remove draft)
glab mr update 123 --ready
```

## Adding Visual Evidence (GIF Recording with --chrome)

When running Claude Code with `--chrome`, you can record GIFs of browser interactions to visually demonstrate feature changes in MRs. This is particularly valuable for UI changes, bug fixes, and workflow demonstrations.

### Workflow

1. **Record a GIF** using the `mcp__claude-in-chrome__gif_creator` tool to capture the feature change or behavior
2. **Upload the GIF** to GitLab via the project uploads API
3. **Reference the upload** in the MR description or comment

### Upload and Reference in MR

```bash
# Upload a file to the current project (returns JSON with a markdown-ready link)
PROJECT_ID=$(glab api "projects/$(git remote get-url origin | sed 's|.*://[^/]*/||;s|\.git$||' | sed 's|/|%2F|g')" --jq '.id')
UPLOAD_RESPONSE=$(glab api "projects/${PROJECT_ID}/uploads" --method POST --field "file=@/path/to/recording.gif")

# Extract the markdown link from the response
MARKDOWN_LINK=$(echo "$UPLOAD_RESPONSE" | jq -r '.markdown')

# Add as a comment on the MR with the visual evidence
glab mr note <mr-number> --message "## Demo

${MARKDOWN_LINK}"
```

You can also include the uploaded GIF directly in MR descriptions under the **Notes** or **How to Test** sections to help reviewers.

### Tips

- Name GIF files meaningfully (e.g., `login-flow-fix.gif` not `recording.gif`)
- Capture extra frames before and after actions for smooth playback
- Great for before/after comparisons - record both states and include in the MR

## MR Title Format

**ALWAYS prepend the Jira ticket ID to the title.**

Format: `TICKET-ID: concise description`

Examples:
- `PROJ-847: Add user profile export`
- `PROJ-912: Handle null response from payment service`

---

# Part 2: Pipelines

## Check Pipeline Status

```bash
# View pipeline status for current branch
glab ci status

# View specific pipeline
glab ci view <pipeline-id>

# List recent pipelines
glab ci list

# View pipeline for specific branch
glab ci status --branch feature-branch

# Open pipeline in browser
glab ci view --web
```

## Pipeline Jobs

```bash
# List jobs in the pipeline
glab ci list

# View specific job logs (trace)
glab ci trace <job-id>

# Download job artifacts
glab ci artifact <job-id>

# View job logs in real-time
glab ci trace <job-id> --follow
```

## Retry and Cancel

```bash
# Retry failed pipeline
glab ci retry <pipeline-id>

# Retry specific failed job
glab ci retry <job-id>

# Cancel running pipeline
glab ci cancel <pipeline-id>

# Delete a pipeline
glab ci delete <pipeline-id>
```

## Trigger New Pipeline

```bash
# Trigger pipeline for current branch
glab ci run

# Trigger with variables
glab ci run --variables "KEY=value"

# Trigger for specific branch
glab ci run --branch main
```

## Common Pipeline Workflows

**Check why pipeline failed:**
```bash
# Get status
glab ci status

# Find failed job
glab ci list

# View failed job logs
glab ci trace <failed-job-id>
```

**Retry after fixing:**
```bash
# Push fix, then retry pipeline
git push
glab ci retry
```

---

# Part 3: Issues

## Create Issue

```bash
# Create a new issue
glab issue create \
  --title "Issue title" \
  --description "Issue description"

# Create with labels and assignee
glab issue create \
  --title "Bug: X doesn't work" \
  --description "Description here" \
  --label "bug,priority::high" \
  --assignee @me

# Create confidential issue
glab issue create \
  --title "Security issue" \
  --description "Details" \
  --confidential
```

## View and List Issues

```bash
# List open issues in current project
glab issue list

# List issues assigned to me
glab issue list --assignee @me

# List issues by label
glab issue list --label "bug"

# List closed issues
glab issue list --state closed

# View specific issue
glab issue view <issue-number>

# Open issue in browser
glab issue view <issue-number> --web
```

## Update and Close Issues

```bash
# Update issue title
glab issue update <issue-number> --title "New title"

# Update issue description
glab issue update <issue-number> --description "New description"

# Add labels
glab issue update <issue-number> --label "new-label"

# Assign to someone
glab issue update <issue-number> --assignee username

# Close issue
glab issue close <issue-number>

# Reopen issue
glab issue reopen <issue-number>
```

## Issue Comments

```bash
# Add comment to issue
glab issue note <issue-number> --message "Comment text"

# View issue with comments
glab issue view <issue-number> --comments
```

---

# Part 4: Repository & Project

## View Repository Info

```bash
# View current repo info
glab repo view

# View repo in browser
glab repo view --web

# View specific repo
glab repo view owner/repo
```

## Clone and Fork

```bash
# Clone a repo
glab repo clone owner/repo

# Clone to specific directory
glab repo clone owner/repo ./my-directory

# Fork a repo
glab repo fork owner/repo

# Fork and clone immediately
glab repo fork owner/repo --clone
```

## Search

```bash
# Search for projects
glab repo search "search-term"

# Search issues across projects
glab search issues "search term"

# Search MRs across projects
glab search mrs "search term"

# Search in specific group
glab repo search "term" --group mygroup
```

## Repository Archive

```bash
# Download repo archive
glab repo archive owner/repo

# Download specific format
glab repo archive owner/repo --format zip
```

---

# Part 5: Releases & Tags

## View Releases

```bash
# List releases
glab release list

# View specific release
glab release view <tag>

# Open release in browser
glab release view <tag> --web
```

## Create Release

```bash
# Create release from tag
glab release create <tag> --notes "Release notes"

# Create release with assets
glab release create <tag> \
  --notes "Release notes" \
  --assets-links '[{"name":"Asset","url":"https://..."}]'

# Create release from notes file
glab release create <tag> --notes-file CHANGELOG.md
```

---

# Part 6: Labels & Milestones

## Labels

```bash
# List labels
glab label list

# Create label
glab label create "label-name" --color "#FF0000" --description "Label description"
```

## Milestones

```bash
# List milestones
glab milestone list

# View milestone
glab milestone view "Sprint 1"
```

---

# Quick Reference

## MR Commands
```bash
DEFAULT_BRANCH=$(git remote show origin | awk '/HEAD branch/ {print $NF}')
glab mr create --draft --squash-before-merge --remove-source-branch --title "title" --description "desc" --target-branch "$DEFAULT_BRANCH"
glab mr list
glab mr list --author=@me
glab mr list --reviewer=@me
glab mr view [mr-number]
glab mr update <mr-number> --title "new title"
glab mr update <mr-number> --description "new desc"
glab mr update <mr-number> --ready
glab mr update <mr-number> --reviewer user1,user2
glab mr merge <mr-number>
glab mr merge <mr-number> --squash
glab mr close <mr-number>
glab mr reopen <mr-number>
glab mr approve <mr-number>
glab mr revoke <mr-number>
glab mr diff <mr-number>
glab mr checkout <mr-number>
glab mr view <mr-number> --web
glab mr note <mr-number> --message "comment"
```

## Pipeline Commands
```bash
glab ci status
glab ci list
glab ci view <pipeline-id>
glab ci view --web
glab ci trace <job-id>
glab ci retry <pipeline-id>
glab ci cancel <pipeline-id>
glab ci run
glab ci run --variables "KEY=value"
glab ci artifact <job-id>
glab ci delete <pipeline-id>
```

## Issue Commands
```bash
glab issue create --title "title" --description "desc"
glab issue list
glab issue list --assignee @me
glab issue list --label "bug"
glab issue view <issue-number>
glab issue update <issue-number> --title "new title"
glab issue close <issue-number>
glab issue reopen <issue-number>
glab issue note <issue-number> --message "comment"
```

## Repo Commands
```bash
glab repo view
glab repo view --web
glab repo clone owner/repo
glab repo fork owner/repo
glab repo search "term"
glab repo archive owner/repo
```

## Other Commands
```bash
glab release list
glab release view <tag>
glab release create <tag> --notes "notes"
glab label list
glab label create "name" --color "#FF0000"
glab milestone list
glab auth status
glab config get
```

---

# Important Notes

- **Always use glab** - Never use curl, GitLab API directly, or MCP GitLab tools
- **Ask for context** - The human knows WHY; you can see WHAT
- **Guide reviewers** - Your description saves them time
- **Be concise** - Respect reviewer attention

## CRITICAL: No AI Attribution

**NEVER include ANY of the following in MR titles, descriptions, issues, or comments:**
- "Generated with Claude Code"
- "Co-Authored-By: Claude"
- Any mention of AI, Claude, or automated assistance
- Any AI-related emoji or signatures

This is non-negotiable. All GitLab content should read as if written entirely by a human engineer.
