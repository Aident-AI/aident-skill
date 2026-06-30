---
name: aident-playbook-skill
description: Generate, manage, execute, and inspect Aident Playbooks from agent environments.
author: Aident
homepage: https://app.aident.ai/playbook
repository: https://github.com/aident-ai/aident-skill
tags:
  - playbook
  - workflows
  - automation
  - cli
  - mcp
categories:
  - productivity
  - development
  - automation
compatibility: Any agent that can run `npx` or speak MCP.
x-aident-skill-id: playbook
x-aident-source-repo: https://github.com/Aident-AI/aident-skill
version: 0.1.1
license: MIT
---

# Aident Playbook - agent setup & usage guide

> **You are an AI agent reading this file** because a user asked for Aident Playbook generation, execution, management, triggers, or execution history. For external-service integration work that is not Playbook-specific, use the public Loadout setup document at `https://aident.ai/SETUP.md`.

## Skill Updates

This Playbook skill is installed from the same `aident-ai/aident-skill` distribution as the Loadout skill. If the user asks to update Aident skills, follow `Update https://aident.ai/SETUP.md`, refresh the local `aident-ai/aident-skill` distribution with the harness's skill installer, and confirm the installed Playbook `version` in this frontmatter is current.

## Quick Setup

1. **Install the CLI**:

   ```bash
   curl -fsSL https://app.aident.ai/cli/install.sh | bash
   ```

   If the installer is unavailable, use `npm install -g @aident-ai/cli` or run commands as `npx -y @aident-ai/cli ...`.

2. **Authenticate**:

   ```bash
   aident login
   ```

   If the shell cannot bind a localhost callback, run `aident login --oob` and ask the user to paste the browser verification code.

3. **Verify the Playbook package**:

   ```bash
   aident --package playbook --help
   aident --package playbook playbooks --help
   ```

## When To Use Playbook

Use the Playbook package when the user asks to:

- Generate or draft a reusable workflow.
- List, read, or manage playbooks.
- Execute a playbook or inspect execution history.
- Activate or manage playbook triggers.
- Read execution messages/results.

## CLI Mode

Use `--package playbook` for one-off Playbook work:

```bash
aident --package playbook playbooks list --json
aident --package playbook playbooks get --playbookId <id> --json
aident --package playbook playbooks generate --prompt "..." --json
aident --package playbook playbooks execute --playbookId <id> --json
aident --package playbook playbooks history --playbookId <id> --json
aident --package playbook executions get --executionId <id> --json
aident --package playbook executions messages --executionId <id> --json
```

To persist Playbook as an add-on package on a machine:

```bash
aident packages add playbook
aident packages list
```

## MCP Mode

Use MCP mode when the host cannot run the CLI or already has MCP tools configured. Configure the MCP client with:

```text
https://app.aident.ai/playbook/mcp
```

Common setup snippets:

- Claude Code: `claude mcp add --transport http aident-playbook https://app.aident.ai/playbook/mcp`
- Claude Desktop: `{"mcpServers":{"aident-playbook":{"command":"npx","args":["-y","mcp-remote","https://app.aident.ai/playbook/mcp"]}}}`
- Cursor: `.cursor/mcp.json` -> `{"mcpServers":{"aident-playbook":{"url":"https://app.aident.ai/playbook/mcp"}}}`
- VS Code: `.vscode/mcp.json` -> `{"servers":{"aident-playbook":{"type":"http","url":"https://app.aident.ai/playbook/mcp"}}}`
- Codex: `codex mcp add aident-playbook --url https://app.aident.ai/playbook/mcp`

After configuring MCP, call the Playbook tools exposed there:

- `auth` for login/status/logout.
- `playbooks_list` to list available playbooks.
- `playbooks_get` to inspect a playbook.
- `playbooks_generate` to generate a playbook.
- `playbooks_execute` to execute a playbook.
- `playbooks_trigger_activate` to activate a trigger.
- `playbooks_history` to inspect playbook history.
- `executions_list`, `executions_get`, and `executions_messages` to inspect execution state and results.

## Error Handling

- `not-authenticated`: run `aident login`, or call MCP `auth` with `{ "action": "login" }`.
- Missing Playbook command: verify the caller used `--package playbook` or the `/playbook/mcp` endpoint.
- Validation error: rerun the command with `--help`, inspect the live schema, fix the input, and retry.
- Forbidden/scope error: explain the missing permission and ask the user to authenticate with the right Aident account.

## Safety

- Confirm before executing playbooks that may mutate external systems.
- Prefer reading playbook details before execution.
- Do not print secrets, tokens, cookies, OAuth codes, or sensitive execution payloads.
- Summarize execution results clearly and link IDs needed for follow-up inspection.

## Support

- Docs: https://docs.aident.ai
- Playbook: https://app.aident.ai/playbook
- Help: help@aident.ai
