---
name: aident
description: >
  Connect to Aident AI — 1000+ integrations, 23,000+ actions, and autonomous
  automation playbooks via MCP (preferred) or REST API. This skill enables
  any AI agent to configure the connection autonomously and begin executing
  workflows, searching skills, managing playbooks, and monitoring dashboards.
version: 1.0.0
author: Aident AI
homepage: https://aident.ai
repository: https://github.com/Aident-AI/open-cuak
tags:
  - automation
  - mcp
  - integrations
  - workflows
  - skills
compatibility:
  - Claude Code (v2.x+)
  - Claude Desktop
  - Cursor IDE
  - VS Code Copilot
  - Windsurf
  - ChatGPT Desktop
  - Gemini CLI
  - Hermes Agent
  - Codex CLI
  - Any MCP-compatible agent
license: MIT
---

# Aident AI — Autonomous Agent Setup

Connect any AI agent to Aident AI's automation platform. Once connected, your
agent can search and execute 1000+ integration skills, create and manage
playbooks, discover templates, and monitor running automations — all through
natural language.

## What You Get

- **1,000+ integrations** — Gmail, Slack, GitHub, Firecrawl, Exa, Shopify,
  Twitter, Notion, and hundreds more
- **23,000+ actions** — send emails, post messages, scrape websites, update
  databases, trigger workflows
- **Playbook engine** — generate, execute, and monitor multi-step automations
  from plain English
- **Templates** — browse and instantiate pre-built automations (competitor
  monitoring, email summaries, SEO audits, etc.)
- **Live dashboard** — monitor active playbooks, execution status, and
  approval requests

## How Connection Works

Two modes. **MCP mode is preferred** — zero manual token management, OAuth
handled by the client. REST fallback available when MCP cannot be configured.

| Mode | Setup | Auth | Best for |
|------|-------|------|----------|
| MCP (preferred) | Configure HTTP MCP server | Browser OAuth (automatic) | All MCP-compatible agents |
| REST fallback | OAuth via curl | OOB token flow | Non-MCP agents, scripting |

---

## PATH A: Auto MCP Configuration (Preferred)

Configure your agent's MCP client to connect to Aident. The server URL is
always:

```
https://app.aident.ai/api/mcp
```

Authentication is handled automatically — your MCP client opens a browser for
OAuth on first connection. The end user just clicks **Approve**.

### Auto-detect Your Platform

Run the command or edit the file that matches your agent:

#### Claude Code
```bash
claude mcp add --transport http aident https://app.aident.ai/api/mcp
```
Verify: `claude mcp list` should show `aident`.

#### Claude Desktop
Edit `~/Library/Application Support/Claude/claude_desktop_config.json` (macOS)
or `%APPDATA%\Claude\claude_desktop_config.json` (Windows):
```json
{
  "mcpServers": {
    "aident": {
      "command": "npx",
      "args": ["-y", "mcp-remote", "https://app.aident.ai/api/mcp"]
    }
  }
}
```
Pro/Max/Team/Enterprise users: **Settings → Connectors → Add** → enter URL.

#### Cursor IDE
Create or edit `.cursor/mcp.json` in the project root:
```json
{
  "mcpServers": {
    "aident": {
      "url": "https://app.aident.ai/api/mcp"
    }
  }
}
```

#### VS Code Copilot
Create or edit `.vscode/mcp.json` in the project root:
```json
{
  "servers": {
    "aident": {
      "type": "http",
      "url": "https://app.aident.ai/api/mcp"
    }
  }
}
```

#### Windsurf
Edit `~/.codeium/windsurf/mcp_config.json`:
```json
{
  "mcpServers": {
    "aident": {
      "serverUrl": "https://app.aident.ai/api/mcp"
    }
  }
}
```

#### ChatGPT Desktop
**Settings → MCP Servers → Add Server** → enter:
```
https://app.aident.ai/api/mcp
```

#### Gemini CLI
Edit `~/.gemini/settings.json`:
```json
{
  "mcpServers": {
    "aident": {
      "httpUrl": "https://app.aident.ai/api/mcp"
    }
  }
}
```

#### Hermes Agent
Edit `~/.hermes/config.yaml`:
```yaml
mcp_servers:
  aident:
    url: "https://app.aident.ai/api/mcp"
    timeout: 120
```

#### Codex CLI
Configure an HTTP MCP server at `https://app.aident.ai/api/mcp`. Refer to
`codex mcp add --help` for exact syntax.

#### Other MCP Agents
Any agent supporting HTTP MCP transport — point it at:
```
https://app.aident.ai/api/mcp
```

### After Configuration — Verify

1. **Restart** your agent so it picks up the new MCP server.
2. Ask the agent:
   ```
   Use Aident to check my auth status
   ```
   Or call the tool directly: `auth_status`
3. If not yet authenticated, the MCP client opens a browser. The user clicks
   **Approve**.
4. Once approved, list available tools:
   ```
   List all Aident tools
   ```
   You should see 22 tools available.

### What Can Go Wrong (MCP)

| Symptom | Fix |
|---------|-----|
| "MCP server not connected" | Check URL is exactly `https://app.aident.ai/api/mcp`. No trailing slash. |
| OAuth window doesn't open | The MCP client may need a browser available. Try a different client. |
| "No tools found" | Connection succeeded but OAuth hasn't completed. Run `auth_status`. |
| Claude Code: `claude mcp add` fails | Ensure Claude Code v2.x+: `claude --version`. Update with `claude update`. |

---

## PATH B: REST API Fallback

Use this path when the agent cannot configure MCP directly (e.g., older
agents, scripted environments, or platforms without MCP support).

### Overview

1. Register an OAuth client
2. Open browser for user authorization
3. Capture the OOB (out-of-band) token
4. Call tools over HTTPS

All state persists in `~/.aident/credentials.json` so subsequent sessions
skip setup.

### Step 1: Resolve Base URL

```bash
BASE_URL="${AIDENT_BASE_URL:-https://app.aident.ai}"
```

Default: `https://app.aident.ai`. Override with `AIDENT_BASE_URL` env var.

### Step 2: Check Existing Credentials

Read `~/.aident/credentials.json`. If it exists with a non-empty
`access_token`:
- If `expires_at` is in the future → skip to **Step 6**.
- If `expires_at` is in the past and `refresh_token` is present → go to
  **Step 5** (refresh).
- Otherwise → continue to **Step 3** (full auth).

If no credentials file → continue to **Step 3**.

### Step 3: Register OAuth Client

```bash
mkdir -p ~/.aident

RESPONSE=$(curl -s -X POST "$BASE_URL/api/mcp/oauth/register" \
  -H "Content-Type: application/json" \
  -d '{
    "redirect_uris": ["'"$BASE_URL"'/mcp/oob"],
    "client_name": "aident-skill-cli",
    "grant_types": ["authorization_code", "refresh_token"],
    "response_types": ["code"],
    "token_endpoint_auth_method": "none"
  }')

CLIENT_ID=$(echo "$RESPONSE" | python3 -c "import json,sys; print(json.load(sys.stdin)['client_id'])")
```

Save `CLIENT_ID` — it's needed for subsequent steps.

### Step 4: Authorize (Browser OOB Flow)

Open the authorization URL in the user's browser:

```bash
AUTH_URL="$BASE_URL/api/mcp/oauth/authorize?response_type=code&client_id=$CLIENT_ID&redirect_uri=$BASE_URL/mcp/oob"

# Open browser (auto-detect OS)
case "$(uname -s)" in
  Darwin)  open "$AUTH_URL" ;;
  Linux)   xdg-open "$AUTH_URL" ;;
  CYGWIN*|MINGW*|MSYS*) start "$AUTH_URL" ;;
esac
```

Tell the user:

> I've opened Aident in your browser. Please log in and click **Approve**.
> Copy the access token shown on screen and paste it here.

When the user provides the token, save it:

```bash
ACCESS_TOKEN="<token from user>"

cat > ~/.aident/credentials.json << EOF
{
  "base_url": "$BASE_URL",
  "client_id": "$CLIENT_ID",
  "access_token": "$ACCESS_TOKEN",
  "refresh_token": "",
  "expires_at": ""
}
EOF
```

### Step 5: Refresh an Expired Token

```bash
REFRESH_RESPONSE=$(curl -s -X POST "$BASE_URL/api/mcp/oauth/token" \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -d "grant_type=refresh_token&client_id=$CLIENT_ID&refresh_token=$REFRESH_TOKEN")

# Extract new tokens
NEW_ACCESS=$(echo "$REFRESH_RESPONSE" | python3 -c "import json,sys; print(json.load(sys.stdin)['access_token'])")
NEW_REFRESH=$(echo "$REFRESH_RESPONSE" | python3 -c "import json,sys; print(json.load(sys.stdin).get('refresh_token', ''))")
EXPIRES=$(echo "$REFRESH_RESPONSE" | python3 -c "import json,sys; print(json.load(sys.stdin).get('expires_at', ''))")

# Update credentials file
python3 -c "
import json
with open('$HOME/.aident/credentials.json') as f: creds = json.load(f)
creds['access_token'] = '$NEW_ACCESS'
creds['refresh_token'] = '$NEW_REFRESH' or creds.get('refresh_token', '')
creds['expires_at'] = '$EXPIRES'
with open('$HOME/.aident/credentials.json', 'w') as f: json.dump(creds, f, indent=2)
"
```

If refresh fails (HTTP 400/401), delete `~/.aident/credentials.json` and
return to **Step 3**.

### Step 6: Call Tools (REST Mode)

```bash
# Load credentials
ACCESS_TOKEN=$(python3 -c "import json; print(json.load(open('$HOME/.aident/credentials.json'))['access_token'])")
BASE_URL=$(python3 -c "import json; print(json.load(open('$HOME/.aident/credentials.json'))['base_url'])")

# Call any tool
curl -s -X POST "$BASE_URL/api/mcp/rest" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $ACCESS_TOKEN" \
  -d '{"tool": "<tool_name>", "arguments": {<args>}}'
```

Parse `result` from the JSON response.

**On HTTP 401:** Token expired. Go to **Step 5** to refresh. If refresh
fails, go to **Step 3**.

---

## Available Tools (22)

### Auth
| Tool | Description |
|------|-------------|
| `auth_status` | Check authentication status (always accessible, no auth needed) |
| `auth_logout` | Revoke token and log out. After calling: delete `~/.aident/credentials.json` |

### Skills & Discovery
| Tool | Description |
|------|-------------|
| `capability_search` | Search skills/integrations by query, type, or scope (hybrid search) |
| `skill_list` | List available skills with pagination |
| `skill_get_info` | Get skill details: input/output schemas, required integrations |
| `skill_execute` | Execute a skill with validated input |

### Integrations
| Tool | Description |
|------|-------------|
| `integration_status` | Check which third-party integrations are connected |
| `integration_connect` | Initiate OAuth connection to a new service |

### Playbooks
| Tool | Description |
|------|-------------|
| `playbook_list` | List your playbooks with status and trigger info |
| `playbook_get_info` | Get playbook details and trigger configuration |
| `playbook_generate` | Generate a new playbook from natural language description |
| `playbook_execute` | Execute a playbook (returns execution ID) or send follow-up message |
| `playbook_update_trigger` | Enable/disable playbook triggers |
| `playbook_execution_history` | Get execution history for a playbook |

### Templates
| Tool | Description |
|------|-------------|
| `template_search` | Search templates by keyword or category |
| `template_list` | List available templates with optional category filtering |
| `template_get_info` | Get detailed template information |
| `template_instantiate` | Create a new playbook from a template |

### Dashboard
| Tool | Description |
|------|-------------|
| `dashboard_active_playbooks` | List playbooks with active triggers or running executions |
| `execution_get_details` | Get execution details, status, and messages |
| `execution_list` | List recent executions across all playbooks |
| `execution_get_messages` | Get simplified chat messages for progress polling |

---

## Quick-Start Examples

### Example 1: MCP Mode (Claude Code)
```
$ claude mcp add --transport http aident https://app.aident.ai/api/mcp
$ claude
> Search Aident for skills related to sending emails
```
Claude discovers the `capability_search` tool, calls it, and returns results.

### Example 2: MCP Mode (Cursor)
1. Create `.cursor/mcp.json` with the aident server URL
2. Restart Cursor
3. In the chat: "Use Aident to list my playbooks"
4. Cursor's agent calls `playbook_list` and shows results

### Example 3: Playbook from Template
```
Use Aident to:
1. Search templates for "competitor monitoring"
2. Instantiate the best match
3. Execute the playbook
```

### Example 4: REST Fallback (curl)
```
# After OAuth setup (Steps 3-4) and token saved:
curl -s -X POST https://app.aident.ai/api/mcp/rest \
  -H "Authorization: Bearer $ACCESS_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"tool": "template_list", "arguments": {"category": "marketing"}}'
```

---

## Credentials File Schema (REST Only)

`~/.aident/credentials.json`:
```json
{
  "base_url": "https://app.aident.ai",
  "client_id": "aident-skill-cli-XXXXXXXX",
  "access_token": "eyJ...",
  "refresh_token": "eyJ...",
  "expires_at": "2026-05-01T12:00:00Z"
}
```

- `AIDENT_TOKEN` env var can bypass the file entirely for advanced/CI use.
  If set, use it directly as the Bearer token.
- `AIDENT_BASE_URL` env var overrides `base_url`.

---

## Security

- **OAuth 2.1**: Industry-standard authorization with PKCE
- **Scoped access**: Category-based permissions (skills, integrations,
  playbooks, templates, dashboard)
- **Revocable**: Revoke anytime from Aident Settings or via `auth_logout`
- **Token refresh**: Automatic refresh on expiry (REST mode)
- **No secrets in config**: MCP mode handles auth transparently; tokens never
  appear in config files

---

## Troubleshooting

| Problem | Likely Cause | Solution |
|---------|-------------|----------|
| MCP tools don't appear | Agent didn't restart after config | Restart the agent |
| "No MCP servers configured" | Config file syntax error | Validate JSON/YAML syntax |
| OAuth window doesn't open | No browser available | Try REST fallback mode instead |
| "401 Unauthorized" (REST) | Token expired | Run Step 5 (refresh) |
| Refresh fails (REST) | Token revoked or expired | Delete credentials file, return to Step 3 |
| Tool returns error | Missing integration | Call `integration_connect`, then retry |
| "MCP SDK not available" (Hermes) | `mcp` package not installed | `pip install mcp` |

---

## Environment Variables

| Variable | Purpose | Default |
|----------|---------|---------|
| `AIDENT_BASE_URL` | Override API base URL | `https://app.aident.ai` |
| `AIDENT_TOKEN` | Bypass credentials file (CI/advanced) | — |

---

## Platform Hints for Agents

When executing this skill, auto-detect the platform:

- **`claude` binary on PATH** → Claude Code → `claude mcp add --transport http`
- **`.cursor/mcp.json` exists** → Cursor → edit that file
- **`.vscode/` directory exists** → VS Code → edit `.vscode/mcp.json`
- **`~/.hermes/config.yaml` exists** → Hermes Agent → add to `mcp_servers`
- **`~/.gemini/` exists** → Gemini CLI → edit `settings.json`
- **`~/.codeium/` exists** → Windsurf → edit `mcp_config.json`
- **Fallback** → REST API mode with OAuth flow

---

## Support

- **Email:** help@aident.ai
- **Discord:** https://discord.gg/hxtEYHuW26
- **Documentation:** https://docs.aident.ai
- **Open source:** https://github.com/Aident-AI/open-cuak
