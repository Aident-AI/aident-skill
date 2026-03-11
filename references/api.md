# REST API Reference

Use the REST API when MCP tools are not available. Same tools, simpler interface -- just Bearer token + JSON.

## Base URL

```
https://app.aident.ai/api/mcp/rest
```

Override with `AIDENT_BASE_URL` to point at a different server:

```bash
export AIDENT_BASE_URL=https://your-server.example.com
```

## Getting a Token

Tokens are persisted to `~/.aident/credentials.json` so you only authenticate once. AI agents handle this automatically (see [SKILL.md](../SKILL.md) for the full flow).

### Option A: OOB flow (browser copy-paste)

Best for scripts and CLI tools that can't run a callback server. The token is saved to `~/.aident/credentials.json` for reuse.

**1. Register a client:**

```bash
curl -X POST ${AIDENT_BASE_URL:-https://app.aident.ai}/api/mcp/oauth/register \
  -H "Content-Type: application/json" \
  -d '{
    "redirect_uris": ["${AIDENT_BASE_URL:-https://app.aident.ai}/mcp/oob"],
    "client_name": "My Script",
    "grant_types": ["authorization_code", "refresh_token"],
    "response_types": ["code"],
    "token_endpoint_auth_method": "none"
  }'
```

Save the `client_id` from the response.

**2. Open in browser:**

```
${AIDENT_BASE_URL:-https://app.aident.ai}/api/mcp/oauth/authorize?response_type=code&client_id=CLIENT_ID&redirect_uri=${AIDENT_BASE_URL:-https://app.aident.ai}/mcp/oob
```

**3. Log in and approve.** The token is displayed on screen. Copy it.

**4. Save credentials:**

```bash
mkdir -p ~/.aident
cat > ~/.aident/credentials.json << 'EOF'
{
  "base_url": "https://app.aident.ai",
  "client_id": "CLIENT_ID",
  "access_token": "<paste token here>"
}
EOF
```

Subsequent requests read `access_token` from this file automatically.

### Option B: Standard OAuth 2.1 PKCE

For applications with a callback server (web apps, sophisticated CLI tools).

**1. Register** with your callback URL:

```bash
curl -X POST ${AIDENT_BASE_URL:-https://app.aident.ai}/api/mcp/oauth/register \
  -H "Content-Type: application/json" \
  -d '{
    "redirect_uris": ["http://localhost:3000/callback"],
    "client_name": "My App",
    "grant_types": ["authorization_code", "refresh_token"],
    "response_types": ["code"],
    "token_endpoint_auth_method": "none"
  }'
```

**2. Generate PKCE pair** (code_verifier + code_challenge).

**3. Open browser** to authorize URL with `code_challenge` and `code_challenge_method=S256`.

**4. Exchange code** for tokens:

```bash
curl -X POST ${AIDENT_BASE_URL:-https://app.aident.ai}/api/mcp/oauth/token \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -d "grant_type=authorization_code&client_id=CLIENT_ID&code=AUTH_CODE&code_verifier=VERIFIER&redirect_uri=http://localhost:3000/callback"
```

**5. Refresh** when expired (access tokens last 1 hour, refresh tokens 30 days):

```bash
curl -X POST ${AIDENT_BASE_URL:-https://app.aident.ai}/api/mcp/oauth/token \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -d "grant_type=refresh_token&client_id=CLIENT_ID&refresh_token=REFRESH_TOKEN"
```

## Calling Tools

### List available tools

```bash
curl -H "Authorization: Bearer $AIDENT_TOKEN" \
  ${AIDENT_BASE_URL:-https://app.aident.ai}/api/mcp/rest
```

Returns `{ "tools": [{ "name": "...", "description": "...", "inputSchema": {...} }, ...] }`.

### Call a tool

```bash
curl -X POST ${AIDENT_BASE_URL:-https://app.aident.ai}/api/mcp/rest \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $AIDENT_TOKEN" \
  -d '{ "tool": "capability_search", "arguments": { "query": "send email", "limit": 5 } }'
```

Returns `{ "result": { ... } }`.

### More examples

```bash
# Execute a skill
curl -X POST ${AIDENT_BASE_URL:-https://app.aident.ai}/api/mcp/rest \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $AIDENT_TOKEN" \
  -d '{
    "tool": "skill_execute",
    "arguments": {
      "skillName": "gmail_send_email",
      "input": { "to": "team@example.com", "subject": "Notes", "body": "..." }
    }
  }'

# List playbooks
curl -X POST ${AIDENT_BASE_URL:-https://app.aident.ai}/api/mcp/rest \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $AIDENT_TOKEN" \
  -d '{ "tool": "playbook_list", "arguments": {} }'

# Check integrations
curl -X POST ${AIDENT_BASE_URL:-https://app.aident.ai}/api/mcp/rest \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $AIDENT_TOKEN" \
  -d '{ "tool": "integration_status", "arguments": {} }'
```

## Error Handling

| HTTP Status | Meaning |
|-------------|---------|
| 200 | Success -- check `result` field |
| 400 | Invalid request body |
| 401 | Invalid or expired token -- refresh and retry |
| 500 | Tool execution error -- check `error` field |

## Advanced Overrides

These environment variables are optional power-user overrides. By default, the skill reads tokens from `~/.aident/credentials.json`.

| Variable | Purpose |
|----------|---------|
| `AIDENT_TOKEN` | Skip credential file and use this Bearer token directly |
| `AIDENT_BASE_URL` | Override the default server (`https://app.aident.ai`) |

## Rate Limits

Standard rate limits apply. If rate limited, wait and retry with exponential backoff.
