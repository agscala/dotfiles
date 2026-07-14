---
name: zdev
description: "Zapier's internal developer CLI. Use when the user wants to search or look up internal engineering documentation (e.g. 'how does X work at Zapier', 'find docs on Y', 'what's our policy for Z'), install or discover available AI assistant skills, look up service metadata from OpsLevel (e.g. 'who owns this service', 'what tier is X', 'show me service info'), set up their developer environment, or wants to run a zdev command."
metadata:
  tags:
    - documentation
    - meta-authoring
  status: recommended
allowed-tools:
  - Bash(NO_INTERACTIVE=1 NO_COLOR=1 zdev:*)
  - Bash(zdev:*)
---

# Zapier Developer CLI (zdev)

`zdev` is Zapier's internal developer CLI for common engineering workflows. It consolidates documentation search (zdocs), AI skill management, service metadata lookup (OpsLevel), and machine setup into a single tool.

**`zdev docs` vs `zdocs` MCP tools:** When both are available, prefer `zdev docs` — it indexes more repositories (including `data-index` and `supernova`) and supports fuzzy matching. The `zdocs` MCP tools query the same core repos but with a different interface.

## Non-interactive mode

Always prefix zdev commands with `NO_INTERACTIVE=1 NO_COLOR=1`. This prevents interactive prompts (fzf pickers, conflict dialogs) from blocking execution and strips ANSI color codes for cleaner output.

```bash
NO_INTERACTIVE=1 NO_COLOR=1 zdev <command>
```

When `NO_INTERACTIVE=1` is set, commands that would normally show an interactive picker require explicit arguments instead. For example, use `zdev skills install <skill-name>` rather than `zdev skills install` without a name.

**Note:** zdev auto-detects non-TTY environments (pipes, CI, AI agents) and disables interactive mode automatically. The `NO_INTERACTIVE=1` prefix is still recommended as an explicit signal but is not strictly required when stdout is not a TTY.

Use `--help` to discover the current subcommands, flags, and usage for any command. The CLI evolves and `--help` is the source of truth. Before running any zdev command you haven't used in this conversation, verify with `--help` first.

```bash
NO_INTERACTIVE=1 NO_COLOR=1 zdev --help
NO_INTERACTIVE=1 NO_COLOR=1 zdev <command> --help
NO_INTERACTIVE=1 NO_COLOR=1 zdev <command> <subcommand> --help
```

## Commands

### `zdev docs` — Search and browse internal documentation

Hybrid local search (SQLite FTS5 + fuzzy matching) across Zapier's internal documentation repositories. Requires one-time setup to clone repos and build the index.

| Command | Description |
|---------|-------------|
| `zdev docs search <query>` | Search docs. Options: `--repo`, `--type` (api/guide/system), `--limit` (default 10) |
| `zdev docs read <repo> <path>` | Read a specific document by repo and path |
| `zdev docs setup` | First-time setup: clone doc repos and build index (~4000 docs, 2-5 min) |
| `zdev docs status` | Show index state and staleness per repo |
| `zdev docs update` | Pull latest docs and rebuild the index if changed |

**Indexed repositories:**

| Repository | Content |
|-----------|---------|
| `internal-api-docs` | Internal API endpoint specs (actions, authentications, webhooks, SQS) |
| `public-api-docs` | Public-facing Zapier Platform API docs |
| `engineering-index` | Engineering guides, runbooks, deploy processes, on-call |
| `data-index` | Data platform docs (dbt, Databricks, pipelines) |
| `supernova` | Supernova design system documentation |

**Error recovery:** If `zdev docs search` returns "No index found" or no results on a broad query, run `zdev docs setup` first (one-time, 2-5 min), then retry. `zdev docs search` works offline against your local index; only `update` and `setup` require network.

**Workflow:** Search first, then read the most relevant result. Present the top 3-5 results to the user with titles and paths. For specific questions, read the best match with `zdev docs read` and summarize it. For broad queries, let the user choose.

```bash
# Search for Zapier-specific topics
NO_INTERACTIVE=1 NO_COLOR=1 zdev docs search "codebox execution"
NO_INTERACTIVE=1 NO_COLOR=1 zdev docs search "zap task lifecycle" --repo internal-api-docs
NO_INTERACTIVE=1 NO_COLOR=1 zdev docs search "incident runbook" --repo engineering-index
NO_INTERACTIVE=1 NO_COLOR=1 zdev docs search "rate limiting" --type api
NO_INTERACTIVE=1 NO_COLOR=1 zdev docs search "feature flags" --limit 5

# Read a specific doc from search results
NO_INTERACTIVE=1 NO_COLOR=1 zdev docs read engineering-index "guides/tools/finding-code.md"
NO_INTERACTIVE=1 NO_COLOR=1 zdev docs read internal-api-docs "endpoints/actions.md"

# Keep the index fresh
NO_INTERACTIVE=1 NO_COLOR=1 zdev docs status
NO_INTERACTIVE=1 NO_COLOR=1 zdev docs update
```

### `zdev skills` — Install and manage AI assistant skills

Browse, install, update, and uninstall skills for Claude Code, Cursor, or other AI assistants. Default source: `gitlab.com/zapier/aidev/shared-skills`.

| Command | Description |
|---------|-------------|
| `zdev skills` | Interactive fzf browser — **not usable by agents**, instruct user to run directly |
| `zdev skills install [name]` | Install a skill by name. Options: `--client`, `--repo`, `--project`, `--location`, `--ref`, `--list` |
| `zdev skills list` | List installed skills |
| `zdev skills update [name]` | Update skills. Options: `--on-conflict cancel/overwrite/backup` |
| `zdev skills uninstall [name]` | Remove an installed skill. Options: `--client`, `--project`, `--location` |
| `zdev skills config` | View or set default client (`--client claude\|cursor\|other`) |

Use `zdev skills install --list` to print available skill names non-interactively. For interactive browsing, instruct the user to run `zdev skills install` directly in their terminal.

**Client paths:**

| Client | Global path | Project path |
|--------|-------------|--------------|
| `claude` | `~/.claude/skills/` | `<project>/.claude/skills/` |
| `cursor` | `~/.cursor/skills/` | `<project>/.cursor/skills/` |
| `other` | Custom via `--location` | N/A |

```bash
# Install / update / remove skills
NO_INTERACTIVE=1 NO_COLOR=1 zdev skills install datadog
NO_INTERACTIVE=1 NO_COLOR=1 zdev skills install --repo https://github.com/anthropics/skills/tree/main/skills/frontend-design
NO_INTERACTIVE=1 NO_COLOR=1 zdev skills install datadog --project /path/to/your/repo
NO_INTERACTIVE=1 NO_COLOR=1 zdev skills install --list
NO_INTERACTIVE=1 NO_COLOR=1 zdev skills list
NO_INTERACTIVE=1 NO_COLOR=1 zdev skills update --on-conflict overwrite
NO_INTERACTIVE=1 NO_COLOR=1 zdev skills uninstall datadog

# Codex or other AI clients
NO_INTERACTIVE=1 NO_COLOR=1 zdev skills config --client other
NO_INTERACTIVE=1 NO_COLOR=1 zdev skills install datadog --location ~/.codex/skills/
```

### `zdev service` — Look up service metadata from OpsLevel

Query service metadata from [OpsLevel](https://app.opslevel.com) — owners, tiers, repositories, tools, tags, and more.

| Command | Description |
|---------|-------------|
| `zdev service info <service-name>` | Display service metadata (owner, tier, lifecycle, repos, tools, tags) |
| `zdev service list` | Browse all services. Interactive fzf picker in TTY, plain list otherwise |
| `zdev service login` | Save your OpsLevel API token to `~/.zdev/config.json` |

**Authentication:** Requires an OpsLevel API token. Resolution order: `OPSLEVEL_API_TOKEN` env var > `~/.zdev/config.json` (saved via `zdev service login`). Generate a token at https://app.opslevel.com/api_tokens.

**NEVER run `zdev service login` from an AI agent session.** It requires interactive input (masked token prompt) that will hang. Instead, instruct the user to run it directly in their terminal, or have them set `OPSLEVEL_API_TOKEN` in their shell profile.

The `<service-name>` matches against OpsLevel aliases, so use the service's short name (e.g., `web-backend`).

```bash
# Look up a service
NO_INTERACTIVE=1 NO_COLOR=1 zdev service info web-backend
NO_INTERACTIVE=1 NO_COLOR=1 zdev service info zapier-api

# List all services (plain text in non-interactive mode)
NO_INTERACTIVE=1 NO_COLOR=1 zdev service list
```

### `zdev setup` — Developer environment setup

**NEVER run `zdev setup` from an AI agent session.** It requires interactive terminal input (password prompts, browser-based auth) that will hang indefinitely. Instead, instruct the user to run `zdev setup` directly in their own terminal.

Runs idempotent onboarding setup. Safe to re-run on an already-configured machine.

| Command | Description |
|---------|-------------|
| `zdev setup` | Standard setup (Xcode CLI, Homebrew, asdf, npm auth, Claude Code, Docker, Git signing) |
| `zdev setup --sre` | Include SRE-specific packages (awscli, kubectl, k9s, tfswitch, etc.) |
| `zdev setup --only <steps>` | Run only specific steps (comma-separated) |
| `zdev setup --skip <steps>` | Skip specific steps (comma-separated) |

**Base steps**: `xcode`, `homebrew`, `packages`, `asdf`, `npm-auth`, `claude-code`, `claude-config`, `docker`, `git-config`, `additional`

**SRE steps** (with `--sre`): `sre-packages`, `sre-resources`

### `zdev update` — Self-update

`zdev update` checks for and installs the latest version. Also auto-checks daily.

### `zdev --feedback` — Give feedback

`zdev --feedback "your feedback text"` sends feedback directly to the Dev Impact team.

## Prerequisites

The `zdev` CLI must be installed. If a command fails with "command not found", look up the installation instructions in the [zdev-cli repository](https://gitlab.com/zapier/zdev-cli) and help the user get set up.

GitLab token resolution (in priority order): `~/.zdev/config.json` `gitlabToken` field > `ZDEV_GITLAB_TOKEN` env var > `GITLAB_TOKEN` env var > `glab auth token`.

## Troubleshooting

| Issue | Solution |
|-------|---------|
| `command not found: zdev` | Install from [zdev-cli repo](https://gitlab.com/zapier/zdev-cli). Requires a GitLab token (see Prerequisites). |
| `zdev service info` returns auth error | Run `zdev service login` in your terminal, or set `OPSLEVEL_API_TOKEN` env var |
| `zdev service login` hangs in agent | Never run login from an agent. Instruct user to run it directly or set `OPSLEVEL_API_TOKEN` |
| `zdev docs search` returns nothing | Run `zdev docs setup` first to clone repos and build the index |
| Stale search results | Run `zdev docs update` to pull latest and rebuild |
| `zdev setup` does too much | Instruct user to use `--only <steps>` or `--skip <steps>` |
| npm auth hangs during setup | Instruct user to run `npm auth login --auth-type=web` directly, then `zdev setup --skip npm-auth` |
| Docker install prompts for password | Instruct user to run `brew install --cask docker` directly, then `zdev setup --skip docker` |
| Interactive picker blocks agent | Ensure `NO_INTERACTIVE=1` prefix is set. Always provide explicit skill names. |
| Need skills in Codex | `zdev skills config --client other` then `zdev skills install <name> --location ~/.codex/skills/` |
| `GitLab token not found` | Set `ZDEV_GITLAB_TOKEN` or `GITLAB_TOKEN` env var, add `gitlabToken` to `~/.zdev/config.json`, or run `glab auth login` |
| `zdev update` fails | Check network connectivity and GitLab token validity. If binary is corrupted, re-install from the [zdev-cli repo](https://gitlab.com/zapier/zdev-cli). |

## Related

- **Source**: [zdev-cli GitLab repo](https://gitlab.com/zapier/zdev-cli)
- **Skills catalog**: [shared-skills GitLab repo](https://gitlab.com/zapier/aidev/shared-skills)
- **Feedback channel**: `#service-zdev-cli` / `#zdev-cli-feedback` on Slack
- **Dashboard**: [zdev CLI Datadog dashboard](https://zapier.datadoghq.com/dashboard/scg-yt5-gn8/zdev-cli-dashboard)
