# Aident Skill

[![Skills.sh](https://img.shields.io/badge/skills.sh-aident--skill-blue)](https://skills.sh/skills/aident-ai/aident-skill)
[![npm](https://img.shields.io/npm/v/%40aident-ai%2Fcli?label=%40aident-ai%2Fcli)](https://www.npmjs.com/package/@aident-ai/cli)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

Access [Aident Loadout](https://aident.ai)'s external-service integrations from any AI assistant. The recommended interface is `@aident-ai/cli`, which defaults to the Loadout package; MCP works as a fallback.

## One-line install (recommended)

**macOS / Linux:**

```bash
curl -fsSL https://app.aident.ai/cli/install.sh | bash
```

**Windows (PowerShell, with Git Bash installed):**

```powershell
& "C:\Program Files\Git\bin\bash.exe" -c 'curl -fsSL https://app.aident.ai/cli/install.sh | bash'
```

The installer requires Node ≥ 18, runs `npm install -g @aident-ai/cli`, then `aident doctor` to verify.

## Install the skill

The CLI is most useful when paired with this skill, which gives your coding agent the focused Loadout command surface:

```bash
npx skills add aident-ai/aident-skill
```

## Post-install

```bash
aident doctor   # Validate installation
aident setup    # Interactive setup wizard (optional)
aident login    # Authenticate (opens browser)
```

## How It Works

### CLI (recommended)

The fastest path. Works with any agent that can shell out — one package, one binary, focused Loadout commands.

```bash
aident login                                              # one-time auth
aident capabilities search --query "send email" --json
aident capabilities execute --name gmail_tools.gmail_send_email --input '{"to":"team@example.com","subject":"Hi","body":"..."}' --json
aident vault status --integrationId gmail_tools --json
aident audit recent --limit 20 --json
```

`@aident-ai/cli` defaults to the Loadout package surface. `aident --help` returns the live Loadout command catalog from the OpenAPI document -- no hard-coded tool lists, no version drift. If installing globally is impossible, examples also work as `npx -y @aident-ai/cli ...`.

### MCP (fallback)

Configure your MCP client to talk to `https://loadout.aident.ai/mcp`. For Playbook workflows, configure `https://app.aident.ai/playbook/mcp` as a separate MCP server. See [references/mcp.md](references/mcp.md) for client-specific setup (Claude Code, Claude Desktop, Cursor, VS Code, Windsurf, ChatGPT, Gemini CLI).

**Quick setup for Claude Code:**

```bash
claude mcp add --transport http aident https://loadout.aident.ai/mcp
```

### Direct OpenAPI (advanced)

The public API surface is exposed through OpenAPI at `/api/openapi/loadout.json` (see [references/api.md](references/api.md)). The CLI and MCP surfaces are wrappers around the same package operations, so prefer the CLI unless the host needs raw HTTP.

## Configuration

The CLI persists settings to `~/.aident/config.json` and credentials to `~/.aident/credentials.json` — the same `~/.aident/` folder used by every other Aident tool.

```bash
aident config set baseUrl https://your-host.example.com   # persistent
aident config show                                        # see all values
aident config path                                        # print the file path
```

| Variable          | Purpose                                                                   |
| ----------------- | ------------------------------------------------------------------------- |
| `AIDENT_BASE_URL` | Override the server for one invocation (default: `https://app.aident.ai`) |
| `AIDENT_TOKEN`    | Skip the credentials file and use this Bearer token directly              |
| `AIDENT_PACKAGE`  | Optional one-off package focus, e.g. `loadout`                            |

### Where files live

| Path                                 | Owner               | Purpose                                 |
| ------------------------------------ | ------------------- | --------------------------------------- |
| `~/.aident/config.json`              | CLI                 | Persistent settings (`baseUrl`, …)      |
| `~/.aident/credentials.json`         | CLI + skill (REST)  | OAuth tokens for `aident` and the skill |
| `~/.aident/sandbox-credentials.json` | Sandbox desktop app | Tokens for the local sandbox runtime    |
| `~/.aident/sandbox-workspaces.json`  | Sandbox desktop app | Tracked workspace directories           |
| `~/.aident/sandbox/`                 | Sandbox daemon      | Daemon PID, status, logs                |

## What You Get

| Category         | Examples                                         |
| ---------------- | ------------------------------------------------ |
| **Discovery**    | Search integrations and actions                  |
| **Details**      | Inspect schemas and integration metadata         |
| **Execution**    | Execute connected integration actions            |
| **Vault**        | Check, connect, and disconnect external services |
| **Audit**        | Review recent Loadout action-call usage          |
| **Auth helpers** | MCP `auth` tool, CLI login/whoami/logout         |

See [SKILL.md](./SKILL.md) for the full instructional spec. Run `aident --help` for the live command list filtered to Loadout and your access.

## Authentication

**CLI:** `aident login` opens a browser for OAuth (PKCE on a localhost loopback). Falls back to OOB copy-paste with `--oob`. Tokens auto-refresh on 401.

**MCP clients:** OAuth sign-in is initiated by the MCP client on first use; tokens are managed by the client.

**Prerequisites:** [Aident account](https://app.aident.ai) with relevant integrations connected (Gmail, Slack, GitHub, …).

## Links

- [CLI on npm](https://www.npmjs.com/package/@aident-ai/cli)
- [Install script](https://app.aident.ai/cli/install.sh)
- [MCP Client Setup](references/mcp.md)
- [OpenAPI Reference](references/api.md)
- [Troubleshooting](references/troubleshooting.md)
- [Setup Guide](https://docs.aident.ai/documentation/mcp-server-setup)
- [Discord](https://discord.gg/hxtEYHuW26)

## License

MIT
