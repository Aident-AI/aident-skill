---
name: aident-mcp-server
description: Access 300+ integrations and automation skills through the Model Context Protocol
author: Aident
homepage: https://aident.ai
repository: https://github.com/aident-ai/aident-mcp-skill
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
version: 1.0.0
license: MIT
---

# Aident MCP Server

Connect to Aident's production-grade automation platform directly from your AI coding assistant. Access 300+ integrations (Gmail, Slack, GitHub, Linear, etc.) and execute complex workflows without leaving your development environment.

## Features

- **300+ Integrations**: Gmail, Slack, GitHub, Linear, Notion, Jira, and more
- **Hybrid Search**: Semantic + keyword search across all skills
- **Type-Safe Execution**: Validated inputs with detailed error messages
- **Skill Metadata**: Full schemas, required integrations, and documentation
- **In-Thread Auth**: Connect integrations directly from your AI assistant when needed
- **OAuth 2.1**: Industry-standard authentication with automatic token management

## Quick Start

### 1. Configure Your MCP Client

#### Claude Code

Add to `~/.config/claude/claude.json`:

```json
{
  "mcpServers": {
    "aident": {
      "url": "https://app.aident.ai/api/mcp"
    }
  }
}
```

#### Cursor IDE

Add to `.cursor/mcp.json`:

```json
{
  "servers": {
    "aident": {
      "url": "https://app.aident.ai/api/mcp"
    }
  }
}
```

### 2. Authenticate

On first connection, your MCP client opens a browser window for OAuth sign-in. After authorizing, you're connected automatically.

### 3. Start Using Skills

Your AI assistant can now search, discover, and execute skills from the Aident platform.

## Available Tools (22)

### Auth (2)
- **auth_status** — Check authentication status (always accessible)
- **auth_logout** — Revoke access token and log out

### Skills (4)
- **skill_search** — Search skills by query, tags, or type using hybrid search
- **skill_list** — List available skills with pagination
- **skill_get_info** — Get detailed metadata including input/output schemas and required integrations
- **skill_execute** — Execute a skill with validated input; prompts for missing integrations

### Integrations (2)
- **integration_status** — Check which integrations are connected
- **integration_connect** — Initiate connection to a third-party service via OAuth

### Playbooks (6)
- **playbook_list** — List your playbooks with status and trigger info
- **playbook_get_info** — Get playbook details including content and trigger configuration
- **playbook_generate** — Generate a new playbook from a natural language description
- **playbook_execute** — Execute a playbook (returns execution ID for tracking)
- **playbook_update_trigger** — Enable or disable playbook triggers
- **playbook_execution_history** — Get execution history for a specific playbook

### Templates (4)
- **template_search** — Search for playbook templates by keyword or category
- **template_list** — List available templates with optional category filtering
- **template_get_info** — Get detailed template information
- **template_instantiate** — Create a new playbook from a template

### Dashboard (4)
- **dashboard_active_playbooks** — List playbooks with active triggers or running executions
- **execution_get_details** — Get execution details including status and messages
- **execution_list** — List recent executions across all playbooks
- **session_get_messages** — Get simplified chat messages for progress polling

## Common Use Cases

### Send Email
```
Execute gmail.send_email to send a summary of our discussion to john@example.com
```

### Create GitHub Issue
```
Execute github.create_issue in repository myorg/myrepo with title "Bug: Login fails" and body "Steps to reproduce..."
```

### Post to Slack
```
Execute slack.post_message to #engineering channel with "Deployment complete"
```

## Security

- **OAuth 2.1 + PKCE**: Industry-standard authentication with automatic token refresh
- **Scoped Access**: Category-based permissions (skills, integrations, playbooks, templates, dashboard)
- **Revocable**: Revoke access anytime from Settings
- **Integration-Aware**: Missing integrations prompt for in-thread authentication rather than failing silently

## Troubleshooting

### "Missing required integrations"
- Run `integration_status` to see which integrations are connected
- Use `integration_connect` to connect the required integration
- Retry the skill after connecting

### "Tools not appearing"
- Restart your MCP client
- Verify the URL in your configuration file

### "Connection timeout"
- Check your firewall/proxy settings
- Ensure HTTPS access to `app.aident.ai`

## Documentation

- Setup Guide: https://docs.aident.ai/mcp-server-setup
- API Reference: https://docs.aident.ai/mcp-api-reference
- Skill Library: https://aident.ai/skills

## Support

- Email: support@aident.ai
- Discord: https://discord.gg/aident
- Documentation: https://docs.aident.ai

## License

MIT License - See LICENSE file for details
