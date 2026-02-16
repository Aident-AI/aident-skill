# MCP Client Setup

Connect your AI assistant to Aident via the Model Context Protocol.

## Server URL

```
https://app.aident.ai/api/mcp
```

## Client Configuration

### Claude Code

Run in your terminal:

```bash
claude mcp add --transport http aident https://app.aident.ai/api/mcp
```

Or add to `~/.claude.json`:

```json
{
  "mcpServers": {
    "aident": {
      "type": "http",
      "url": "https://app.aident.ai/api/mcp"
    }
  }
}
```

### Claude Desktop

Add to your config file (`~/Library/Application Support/Claude/claude_desktop_config.json` on macOS, `%APPDATA%\Claude\claude_desktop_config.json` on Windows):

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

Or on **Pro/Max/Team/Enterprise** plans: **Settings → Connectors → Add** and enter `https://app.aident.ai/api/mcp`.

### Cursor IDE

Add to `.cursor/mcp.json` in your project root:

```json
{
  "mcpServers": {
    "aident": {
      "url": "https://app.aident.ai/api/mcp"
    }
  }
}
```

### VS Code (Copilot)

Add to `.vscode/mcp.json` in your project root:

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

### Windsurf

Add to `~/.codeium/windsurf/mcp_config.json`:

```json
{
  "mcpServers": {
    "aident": {
      "serverUrl": "https://app.aident.ai/api/mcp"
    }
  }
}
```

### ChatGPT Desktop

Go to Settings → MCP Servers → Add Server, then enter:

```
https://app.aident.ai/api/mcp
```

### Gemini CLI

Add to `~/.gemini/settings.json`:

```json
{
  "mcpServers": {
    "aident": {
      "httpUrl": "https://app.aident.ai/api/mcp"
    }
  }
}
```

### Other MCP Clients

Any MCP-compatible client (Codex, Goose, Kiro, OpenCode, Antigravity, Factory, etc.) can connect using the server URL `https://app.aident.ai/api/mcp`. Refer to your client's documentation for where to add MCP server configurations.

## Authentication

On first connection, your MCP client opens a browser window for OAuth sign-in. After authorizing, you're connected automatically. No manual token management needed.

To log out or switch accounts, use the `auth_logout` tool, then reconnect to sign in with a different account.

## Verify Connection

Ask your AI assistant to use an Aident tool. You should see 22 tools available. Try:

```
Use Aident to list my available skills
```

See [SKILL.md](../SKILL.md) for the full tool list.
