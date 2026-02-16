# Aident Skill

[![Skills.sh](https://img.shields.io/badge/skills.sh-aident--mcp--server-blue)](https://skills.sh/skills/aident-ai/aident-skill)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

Access [Aident](https://aident.ai)'s 1000+ integrations and automation platform from any AI assistant. Works with MCP clients and skill-only agents.

## Option A (Recommended): MCP

Best experience. Your AI assistant gets direct access to 22 tools.

```bash
npx skills add aident-ai/aident-skill
```

Or configure your client manually -- see [references/mcp.md](references/mcp.md) for all clients (Claude Code, Claude Desktop, Cursor, VS Code, Windsurf, ChatGPT, Gemini CLI, etc.).

**Quick setup for Claude Code:**
```bash
claude mcp add --transport http aident https://app.aident.ai/api/mcp
```

## Option B: REST API (No MCP)

For skill-only agents without MCP support. Same tools, simpler interface.

1. Get a Bearer token ([references/api.md](references/api.md)) -- browser copy-paste or standard OAuth
2. POST to `https://app.aident.ai/api/mcp/rest` with `{ "tool": "...", "arguments": {...} }`
3. See [examples/curl/](examples/curl/) for ready-to-use examples

## What You Get

| Category | Tools | Examples |
|----------|-------|---------|
| **Auth** | 2 | Check status, logout / switch accounts |
| **Skills** | 4 | Search, list, inspect, execute 1000+ integrations |
| **Integrations** | 2 | Check connected services, connect new ones |
| **Playbooks** | 6 | Generate, execute, manage automated workflows |
| **Templates** | 4 | Browse and instantiate pre-built playbooks |
| **Dashboard** | 4 | Monitor active playbooks and executions |

See [SKILL.md](./SKILL.md) for full tool descriptions and dual-mode usage instructions.

## Authentication

**MCP clients:** OAuth sign-in opens automatically on first use. Tokens are managed by the client.

**REST API:** Get a Bearer token via browser copy-paste or OAuth 2.1 PKCE flow. See [references/api.md](references/api.md).

**Prerequisites**: [Aident account](https://app.aident.ai) with connected integrations (Gmail, Slack, GitHub, etc.)

## Links

- [MCP Client Setup](references/mcp.md)
- [REST API Reference](references/api.md)
- [Troubleshooting](references/troubleshooting.md)
- [Setup Guide](https://docs.aident.ai/documentation/mcp-server-setup)
- [API Reference](https://docs.aident.ai/documentation/mcp-api-reference)
- [Discord](https://discord.gg/hxtEYHuW26)

## License

MIT
