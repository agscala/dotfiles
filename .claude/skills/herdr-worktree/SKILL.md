---
name: herdr-worktree
description: >
  Create a dedicated herdr worktree (its own herdr workspace, via `herdr worktree
  create`) with an appropriate auto-generated branch name, then launch Claude in
  PLAN MODE in that workspace's ROOT pane with the task as its prompt so it
  researches and drafts a plan for the work immediately. Use when the user says
  "/herdr-worktree", "make a herdr worktree", "new worktree in herdr", or wants to
  spin up an isolated branch checkout with an agent ready to plan.
metadata:
  tags:
    - herdr
    - git
    - worktree
---

# herdr-worktree

Spin up an isolated worktree for a task as its **own herdr workspace** and start
Claude there in **plan mode**, running in the workspace's **root pane**, so it
immediately produces a plan for the requested work (rather than editing right
away).

**Invocation:** `/herdr-worktree [directory] [task / prompt] [in <space>]`
All arguments optional — infer per the steps below. The task/prompt drives the
branch name *and* is handed to the new Claude as its planning prompt.

> **Default = a real herdr worktree.** When the user asks for a "herdr worktree",
> they mean a dedicated worktree **workspace** created by `herdr worktree create`
> (which is what shows up as a worktree in herdr), with Claude running in that
> workspace's root pane. Do **not** create a plain `git worktree add` checkout and
> drop it into a tab — that is only the fallback in the "tab in an existing space"
> section below, and only when the user explicitly wants it inside a named space.

## Key facts (verified against herdr 0.7.1)

- **`herdr worktree create --cwd <repo> --branch <name> --base <ref> --label <text> --focus`**
  creates the git worktree *and* opens a dedicated workspace for it in one call.
  JSON out: `result.workspace.workspace_id`, `result.root_pane.pane_id`,
  `result.tab.tab_id`, and `result.workspace.worktree.checkout_path`. **This is
  the primary tool** — it is what makes a "herdr worktree."
- **Run the agent in the ROOT pane — do NOT `--split`.** For a worktree workspace,
  Claude belongs in the workspace's root pane (`result.root_pane.pane_id`). Launch
  it with `herdr pane run <root_pane_id> "<command>"`. Using
  `herdr agent start … --split right` here is wrong: it adds an extra pane, the
  launched agent pane can vanish, and a herdr autostart/dashboard pane (e.g. a
  "reviewr" TUI) may already occupy the split — leaving Claude not where expected.
- **Base ref:** detect the repo's real default branch with
  `git -C <repo> symbolic-ref refs/remotes/origin/HEAD` (→ e.g.
  `refs/remotes/origin/staging`). Do **not** assume `main`/`master` — many repos
  (e.g. identity-fe) default to `staging`.
- **The invoking agent's space** is in env vars, not "focused" (which drifts):
  `$HERDR_WORKSPACE_ID`, `$HERDR_TAB_ID`, `$HERDR_PANE_ID`.
- **Claude plan mode:** `claude --permission-mode plan "<prompt>"` starts Claude in
  plan mode; it researches and calls ExitPlanMode with a plan.
- **`herdr worktree list [--cwd <repo>]`** shows existing worktrees;
  **`herdr workspace list`** maps `label` → `workspace_id`.
- Checkout location defaults to `<worktrees.directory>/<repo>/<branch>`, where
  `[worktrees] directory` defaults to `~/.herdr/worktrees` (config may override).

### Prompt quoting through two shells (important)

`herdr pane run <pane>` sends the command to the pane's shell (fish), so the
prompt passes through **two** shell layers (your shell → the pane's fish). Make it
robust by:

- Wrapping the whole command arg in **double quotes** and the claude prompt in
  **single quotes**: `herdr pane run <pane> "claude --permission-mode plan '<prompt>'"`.
- Keeping the prompt free of `'` (single quote), `"` (double quote), `$`, and
  backticks. Braces `{}`, pipes `|`, and parentheses `()` are safe because they
  sit inside quotes. Phrase JSON as words, e.g. write `a JSON body of valid true
  or false` instead of `{"valid": true|false}`.

## Steps (primary: dedicated worktree workspace)

1. **Resolve the source repo directory.** Use the directory argument if given,
   else the invoking pane's cwd (`herdr pane current --current` →
   `result.pane.cwd`, or `$PWD`). Validate + get the root:
   ```sh
   git -C <dir> rev-parse --is-inside-work-tree   # must be: true
   git -C <dir> rev-parse --show-toplevel          # repo root
   ```
   If not a work tree, stop and ask for a valid repo directory.

2. **Choose a branch name** (kebab-case, concise). Derive from the task; prefix a
   ticket key if present (e.g. `ent-356-short-description`). Ensure it is free:
   `git -C <repo> branch --list <name>`; adjust on collision.

3. **Pick the base ref.** `git -C <repo> symbolic-ref refs/remotes/origin/HEAD`
   (strip to the branch name), unless the user specifies otherwise.

4. **Create the worktree workspace:**
   ```sh
   herdr worktree create --cwd <repo_root> --branch <branch> --base <base> \
     --label <branch> --focus
   ```
   Capture `result.workspace.workspace_id`, `result.root_pane.pane_id`, and
   `result.workspace.worktree.checkout_path` from the JSON.

5. **Launch Claude in PLAN MODE in the ROOT pane:**
   ```sh
   herdr pane run <root_pane_id> "claude --permission-mode plan '<prompt>'"
   ```
   Build `<prompt>` from the user's full task (richer than the branch slug),
   following the quoting rules above. Include the checkout path, branch, and repo
   so Claude knows its context, and explicitly ask it to investigate and produce a
   plan without changing anything until approved. Example skeleton:
   `You are in a fresh herdr worktree at <checkout_path> on branch <branch> (repo <repo_name>, based on <base>). Task: <task>. Investigate the codebase and produce a plan; do not make changes until the plan is approved.`

6. **Verify it started.** `herdr pane read <root_pane_id> --source visible --lines 30`
   — confirm the Claude UI is up and shows `plan mode on`. (Give it a moment; the
   first read may catch the prompt still echoing.)

7. **Report.** Tell the user the branch, checkout path, the new workspace id +
   label, and that Claude is running in its root pane in plan mode drafting a plan.

## Alternative: a tab inside an existing space (only if explicitly asked)

Use this **only** when the user wants the worktree placed inside a specific,
existing space (e.g. "in <label>") rather than as its own workspace. Note this
produces a plain git checkout shown in `herdr worktree list` but not a herdr
worktree-workspace.

1. Resolve the target space: `$HERDR_WORKSPACE_ID`, or resolve the named space via
   `herdr workspace list`.
2. Create the checkout: `git -C <repo_root> worktree add -b <branch> <worktrees_dir>/<repo_name>/<branch> <base>`.
3. Open a tab: `herdr tab create --workspace <target> --cwd <checkout_path> --label <branch> --focus`
   → capture `result.tab.tab_id` and `result.root_pane.pane_id`.
4. Launch Claude in that tab's **root pane**:
   `herdr pane run <root_pane_id> "claude --permission-mode plan '<prompt>'"`.
   (Same quoting rules. Prefer running in the tab's root pane over `--split`.)

## Notes & failure handling

- **Cleaning up a mistaken plain checkout:** `git -C <repo> worktree remove --force <checkout_path>`
  then `git -C <repo> branch -D <branch>`.
- **Closing stray tabs/panes:** `herdr tab close <tab_id>` (positional, not
  `--tab`); `herdr pane close <pane_id>`.
- **Removing a worktree workspace** later:
  `herdr worktree remove --workspace <workspace_id> [--force]`.
- Inspect state while debugging: `herdr tab list --workspace <ID>`,
  `herdr pane list --workspace <ID>`, `herdr pane read <pane_id> --source visible`.
- If you ever do use `herdr agent start … -- <argv>`, everything after `--` is the
  full command line (argv[0] = the executable), so it must start with `claude`.
- No `herdr server reload-config` needed — these are live API calls.
