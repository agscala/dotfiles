---
name: zinnia-mcp-setup
description: Use when a user wants to set up, install, or configure the Zinnia MCP server for Claude Code or Cursor. Handles adding the zinnia-mcp server configuration so AI assistants can access Zinnia design system documentation.
user_invocable: true
allowed-tools:
  - Bash(claude mcp add:*)
  - Bash(pnpx @zapier/zinnia-mcp@latest:*)
  - Read
  - Write
  - Edit
  - Glob
---

# Set Up Zinnia MCP

You are configuring the Zinnia MCP server so the user's AI assistant can access Zapier's Zinnia Design System documentation — components, design tokens, and universal layout patterns.

## Prerequisites

- Node.js 22+
- pnpm available in PATH
- npm authentication configured for private `@zapier` packages

## Setup for Claude Code

Run this command to add the MCP server at the user level:

```bash
claude mcp add zinnia-mcp -s user -- pnpx @zapier/zinnia-mcp@latest
```

Alternatively, add to `~/.claude/settings.json` (user-level) or `.mcp.json` (project-level):

```json
{
  "mcpServers": {
    "zinnia-mcp": {
      "command": "pnpx",
      "args": ["@zapier/zinnia-mcp@latest"]
    }
  }
}
```

After setup, tell the user to run `/mcp` in Claude Code to connect.

## Setup for Cursor

Add to `~/.cursor/mcp.json` (user-level) or `.cursor/mcp.json` (project-level):

```json
{
  "mcpServers": {
    "zinnia-mcp": {
      "command": "pnpx",
      "args": ["@zapier/zinnia-mcp@latest"]
    }
  }
}
```

After setup, tell the user to restart Cursor to connect.

## Setup Workflow

1. Ask the user which tools they want to configure: Claude Code, Cursor, or both.
2. Ask whether they want user-level (global) or project-level configuration.
3. For Claude Code: prefer the `claude mcp add` CLI command for user-level setup. For project-level, edit `.mcp.json`.
4. For Cursor: edit the appropriate `mcp.json` file. If the file already exists, merge the `zinnia-mcp` entry into the existing `mcpServers` object — do not overwrite other servers.
5. Verify the setup by checking that the config file contains the correct entry.

## What Zinnia MCP Provides

Once configured, the following tools become available:

| Tool | Description |
|------|-------------|
| `list_components` | Browse all available components by package |
| `get_component_docs` | Get full documentation for a specific component |
| `list_tokens` | List design token categories (semantic/primitive) |
| `get_token_docs` | Get token values in CSS, JS, and SCSS formats |
| `get_universal_layout_docs` | UniversalLayout documentation (hooks, types, constants) |
| `get_component_examples` | Get raw Storybook story file for a component |
| `search` | Full-text search across all documentation |

## Troubleshooting

If the server fails to connect:

1. Verify Node.js 22+ is available: `node --version`
2. Verify pnpm is available: `pnpm --version`
3. Check npm auth for private `@zapier` packages: `npm whoami --registry https://registry.npmjs.org`
4. If `pnpx` is not found, the user may need to specify the full path to node in the config:

```json
{
  "mcpServers": {
    "zinnia-mcp": {
      "command": "/usr/local/bin/node",
      "args": ["/path/to/pnpx", "@zapier/zinnia-mcp@latest"]
    }
  }
}
```
