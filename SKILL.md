---
name: aident-mcp-server
description: |
  Access Aident's 1000+ integrations and automation platform.
  Prefer MCP tools if available; otherwise use HTTPS API fallback.
author: Aident
homepage: https://aident.ai
repository: https://github.com/aident-ai/aident-skill
tags:
  - automation
  - integrations
  - skills
  - workflows
  - mcp
categories:
  - productivity
  - development
  - automation
compatibility: MCP-capable clients (preferred) and skill-capable agents (REST fallback)
version: 0.1.0
license: MIT
---

# Aident (Dual-mode: MCP preferred, HTTPS fallback)

Access 1k+ integrations (Gmail, Slack, GitHub, Firecrawl, Exa, etc.), create and manage automation playbooks, discover templates, and monitor all running automations from a command center dashboard.

## What this skill does

- Search and execute 1000+ integration skills (email, messaging, project management, web scraping, etc.)
- Generate, execute, and manage automation playbooks from natural language
- Browse and instantiate pre-built playbook templates
- Monitor active automations and track execution results
- Connect new third-party integrations on-the-fly

It supports two execution modes:
1. **MCP mode (preferred)**: use MCP tools from the `aident` server.
2. **REST API fallback mode**: call `POST /api/mcp/rest` with `{ tool, arguments }` when MCP tools are unavailable.

## Decide which mode to use

Use **MCP mode** if the client has MCP tools available named like:
- `skill_search`, `skill_list`, `skill_get_info`, `skill_execute`
- `playbook_list`, `playbook_generate`, `playbook_execute`
- `template_search`, `template_list`, `template_instantiate`
- `integration_status`, `integration_connect`
- `dashboard_active_playbooks`, `execution_list`

Otherwise use **REST API fallback**.

### MCP mode (preferred)

**When:** The client is connected to the Aident MCP server and can call tools like `skill_search`, `playbook_list`, etc.

**Setup:** See [references/mcp.md](references/mcp.md) for client configuration.

**Workflow:**
1. Collect required inputs from the user.
2. Call the relevant tool(s) directly.
3. Handle errors:
   - If auth error: ask the user to reconnect (`auth_logout` then reconnect).
   - If missing integration: call `integration_connect` to connect it, then retry.
4. Return results in a clean format.

### REST API fallback mode

**When:** No Aident MCP tools are available in the client.

**Setup:** See [references/api.md](references/api.md) for authentication and API usage.

**Workflow:**
1. Get an Aident Bearer token.
2. Send POST requests to `https://app.aident.ai/api/mcp/rest` with `{ "tool": "...", "arguments": {...} }`.
3. Parse the `result` field from the response.

> If the client can make HTTP requests directly, use that. Otherwise provide copy-paste `curl` commands from [examples/curl/](examples/curl/).

**Example request:**

```bash
curl -X POST https://app.aident.ai/api/mcp/rest \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $AIDENT_TOKEN" \
  -d '{ "tool": "skill_search", "arguments": { "query": "send email", "limit": 5 } }'
```

## Available Tools (22)

### Auth (2)
- **auth_status** -- Check authentication status (always accessible)
- **auth_logout** -- Revoke access token and log out

### Skills (4)
- **skill_search** -- Search skills by query, tags, or type using hybrid search
- **skill_list** -- List available skills with pagination
- **skill_get_info** -- Get detailed metadata including input/output schemas and required integrations
- **skill_execute** -- Execute a skill with validated input; prompts for missing integrations

### Integrations (2)
- **integration_status** -- Check which integrations are connected
- **integration_connect** -- Initiate connection to a third-party service via OAuth

### Playbooks (6)
- **playbook_list** -- List your playbooks with status and trigger info
- **playbook_get_info** -- Get playbook details including content and trigger configuration
- **playbook_generate** -- Generate a new playbook from a natural language description
- **playbook_execute** -- Execute a playbook (returns execution ID for tracking)
- **playbook_update_trigger** -- Enable or disable playbook triggers
- **playbook_execution_history** -- Get execution history for a specific playbook

### Templates (4)
- **template_search** -- Search for playbook templates by keyword or category
- **template_list** -- List available templates with optional category filtering
- **template_get_info** -- Get detailed template information
- **template_instantiate** -- Create a new playbook from a template

### Dashboard (4)
- **dashboard_active_playbooks** -- List playbooks with active triggers or running executions
- **execution_get_details** -- Get execution details including status and messages
- **execution_list** -- List recent executions across all playbooks
- **session_get_messages** -- Get simplified chat messages for progress polling

## Safety & privacy

- Never request secrets in plain text if the platform has secret storage.
- If the user pastes a token, suggest they rotate it and store it securely.
- Only send necessary fields to the service.
- All tokens are scoped -- request only the permissions you need.

## Examples

### Example 1 -- MCP mode

User: "Find skills for sending emails and send a meeting summary to team at example.com"

Assistant:
- Call `skill_search` with `{ "query": "send email" }`
- Review results, pick best match (e.g. `gmail_send_email`)
- Call `skill_execute` with `{ "skillId": "gmail_send_email", "input": { "to": "team@example.com", "subject": "Meeting Summary", "body": "..." } }`
- Present confirmation to user

### Example 2 -- REST API fallback

User: "List my playbooks"

Assistant:
- Confirm Bearer token is available
- POST to `https://app.aident.ai/api/mcp/rest`:
  ```json
  {
    "tool": "playbook_list",
    "arguments": {}
  }
  ```
- Parse the `result` field from response to extract playbooks array
- Present playbook list to user

## Security

- **OAuth 2.1 + PKCE**: Industry-standard authentication with automatic token refresh
- **Scoped Access**: Category-based permissions (skills, integrations, playbooks, templates, dashboard)
- **Revocable**: Revoke access anytime from Settings
- **Integration-Aware**: Missing integrations prompt for connection rather than failing silently

## Documentation

- Setup Guide: https://docs.aident.ai/documentation/mcp-server-setup
- API Reference: https://docs.aident.ai/documentation/mcp-api-reference
- Troubleshooting: [references/troubleshooting.md](references/troubleshooting.md)

## Support

- Email: help@aident.ai
- Discord: https://discord.gg/hxtEYHuW26
- Documentation: https://docs.aident.ai

## License

MIT License - See LICENSE file for details
