# Aident MCP Server Skill

[![Skills.sh](https://img.shields.io/badge/skills.sh-aident--mcp--server-blue)](https://skills.sh/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

Connect [Aident](https://aident.ai)'s automation platform to Claude Code, Cursor, and 35+ MCP-compatible AI agents. Access 300+ integrations and 22 tools for skills, playbooks, templates, and dashboard management.

## Install

```bash
npx skills add aident-ai/aident-mcp-skill
```

Or configure your MCP client directly:

**Claude Code** (`~/.config/claude/claude.json`):
```json
{
  "mcpServers": {
    "aident": {
      "url": "https://app.aident.ai/api/mcp"
    }
  }
}
```

**Cursor IDE** (`.cursor/mcp.json`):
```json
{
  "servers": {
    "aident": {
      "url": "https://app.aident.ai/api/mcp"
    }
  }
}
```

## What You Get

| Category | Tools | Examples |
|----------|-------|---------|
| **Auth** | 2 | Check status, logout |
| **Skills** | 4 | Search, list, inspect, execute 300+ integrations |
| **Integrations** | 2 | Check connected services, connect new ones |
| **Playbooks** | 6 | Generate, execute, manage automated workflows |
| **Templates** | 4 | Browse and instantiate pre-built playbooks |
| **Dashboard** | 4 | Monitor active playbooks and executions |

See [SKILL.md](./SKILL.md) for full tool descriptions.

## Authentication

On first use, your MCP client opens a browser for OAuth sign-in. Tokens are managed automatically.

**Prerequisites**: [Aident account](https://app.aident.ai) with connected integrations (Gmail, Slack, GitHub, etc.)

## Links

- [Setup Guide](https://docs.aident.ai/mcp-server-setup)
- [Skill Library](https://aident.ai/skills)
- [Support](https://docs.aident.ai)

## License

MIT
