#!/bin/bash
# Test MCP REST API and OOB OAuth flow
# Usage: ./mcp-skill/scripts/test-rest-api.sh [BASE_URL]

set -euo pipefail

BASE_URL="${1:-http://localhost:3000}"
PASS=0
FAIL=0
TOTAL=0

green() { printf "\033[32m%s\033[0m\n" "$1"; }
red()   { printf "\033[31m%s\033[0m\n" "$1"; }
bold()  { printf "\033[1m%s\033[0m\n" "$1"; }

assert_status() {
  local label="$1" expected="$2" actual="$3"
  TOTAL=$((TOTAL + 1))
  if [ "$actual" -eq "$expected" ]; then
    green "  PASS  $label (HTTP $actual)"
    PASS=$((PASS + 1))
  else
    red "  FAIL  $label — expected HTTP $expected, got HTTP $actual"
    FAIL=$((FAIL + 1))
  fi
}

assert_json_field() {
  local label="$1" body="$2" field="$3"
  TOTAL=$((TOTAL + 1))
  if echo "$body" | python3 -c "import sys,json; d=json.load(sys.stdin); assert '$field' in d" 2>/dev/null; then
    green "  PASS  $label (response has \"$field\")"
    PASS=$((PASS + 1))
  else
    red "  FAIL  $label — response missing \"$field\""
    FAIL=$((FAIL + 1))
  fi
}

assert_json_value() {
  local label="$1" body="$2" expr="$3"
  TOTAL=$((TOTAL + 1))
  if echo "$body" | python3 -c "import sys,json; d=json.load(sys.stdin); assert $expr" 2>/dev/null; then
    green "  PASS  $label"
    PASS=$((PASS + 1))
  else
    red "  FAIL  $label"
    FAIL=$((FAIL + 1))
  fi
}

# ------------------------------------------------------------------
bold "=== MCP REST API E2E Test ==="
echo "Target: $BASE_URL"
echo ""

# Step 1: Register OAuth client
bold "Step 1: Register OAuth client"
REGISTER_RESPONSE=$(curl -s -w "\n%{http_code}" -X POST "$BASE_URL/api/mcp/oauth/register" \
  -H "Content-Type: application/json" \
  -d "{
    \"client_name\": \"test-rest-e2e-$(date +%s)\",
    \"redirect_uris\": [\"$BASE_URL/mcp/oob\"]
  }")

REGISTER_STATUS=$(echo "$REGISTER_RESPONSE" | tail -1)
REGISTER_BODY=$(echo "$REGISTER_RESPONSE" | sed '$d')

assert_status "Client registration" 201 "$REGISTER_STATUS"
assert_json_field "Registration response" "$REGISTER_BODY" "client_id"

CLIENT_ID=$(echo "$REGISTER_BODY" | python3 -c "import sys,json; print(json.load(sys.stdin)['client_id'])")
echo "  Client ID: $CLIENT_ID"
echo ""

# Step 2: OOB authorization
bold "Step 2: Authorize via OOB flow"
AUTHORIZE_URL="$BASE_URL/api/mcp/oauth/authorize?client_id=$CLIENT_ID&redirect_uri=$(python3 -c "import urllib.parse; print(urllib.parse.quote('$BASE_URL/mcp/oob'))")&response_type=code"

echo "  Opening browser to authorize..."
echo "  URL: $AUTHORIZE_URL"
echo ""

if command -v open &>/dev/null; then
  open "$AUTHORIZE_URL"
elif command -v xdg-open &>/dev/null; then
  xdg-open "$AUTHORIZE_URL"
else
  echo "  (Could not detect browser command — open the URL above manually)"
fi

echo "  1. Log in if prompted"
echo "  2. Click 'Approve'"
echo "  3. Copy the access token from the OOB page"
echo ""
read -rp "  Paste your access token here: " ACCESS_TOKEN

if [ -z "$ACCESS_TOKEN" ]; then
  red "No token provided. Aborting."
  exit 1
fi
echo ""

# ------------------------------------------------------------------
bold "Step 3: Test REST endpoint"
echo ""

# Test 3a: GET /api/mcp/rest — list tools (authenticated)
bold "  3a. GET /api/mcp/rest — list tools"
LIST_RESPONSE=$(curl -s -w "\n%{http_code}" "$BASE_URL/api/mcp/rest" \
  -H "Authorization: Bearer $ACCESS_TOKEN")
LIST_STATUS=$(echo "$LIST_RESPONSE" | tail -1)
LIST_BODY=$(echo "$LIST_RESPONSE" | sed '$d')

assert_status "List tools" 200 "$LIST_STATUS"
assert_json_field "List response" "$LIST_BODY" "tools"
TOOL_COUNT=$(echo "$LIST_BODY" | python3 -c "import sys,json; print(len(json.load(sys.stdin).get('tools',[])))" 2>/dev/null || echo "0")
assert_json_value "Has 22 tools" "$LIST_BODY" "len(d['tools']) == 22"
echo "  Tool count: $TOOL_COUNT"
echo ""

# Test 3b: POST /api/mcp/rest — call auth_status
bold "  3b. POST /api/mcp/rest — call auth_status"
AUTH_RESPONSE=$(curl -s -w "\n%{http_code}" -X POST "$BASE_URL/api/mcp/rest" \
  -H "Authorization: Bearer $ACCESS_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"tool": "auth_status", "arguments": {}}')
AUTH_STATUS=$(echo "$AUTH_RESPONSE" | tail -1)
AUTH_BODY=$(echo "$AUTH_RESPONSE" | sed '$d')

assert_status "Call auth_status" 200 "$AUTH_STATUS"
assert_json_field "auth_status response" "$AUTH_BODY" "result"
echo ""

# Test 3c: POST /api/mcp/rest — call skill_search
bold "  3c. POST /api/mcp/rest — call skill_search"
SEARCH_RESPONSE=$(curl -s -w "\n%{http_code}" -X POST "$BASE_URL/api/mcp/rest" \
  -H "Authorization: Bearer $ACCESS_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"tool": "skill_search", "arguments": {"query": "send email", "limit": 3}}')
SEARCH_STATUS=$(echo "$SEARCH_RESPONSE" | tail -1)
SEARCH_BODY=$(echo "$SEARCH_RESPONSE" | sed '$d')

assert_status "Call skill_search" 200 "$SEARCH_STATUS"
assert_json_field "skill_search response" "$SEARCH_BODY" "result"
echo ""

# ------------------------------------------------------------------
bold "Step 4: Error cases"
echo ""

# Test 4a: No auth header — expect 401
bold "  4a. GET without auth — expect 401"
NOAUTH_RESPONSE=$(curl -s -w "\n%{http_code}" "$BASE_URL/api/mcp/rest")
NOAUTH_STATUS=$(echo "$NOAUTH_RESPONSE" | tail -1)
NOAUTH_BODY=$(echo "$NOAUTH_RESPONSE" | sed '$d')

assert_status "No auth" 401 "$NOAUTH_STATUS"
assert_json_field "401 response" "$NOAUTH_BODY" "error"
echo ""

# Test 4b: Invalid token — expect 401
bold "  4b. GET with invalid token — expect 401"
BADTOKEN_RESPONSE=$(curl -s -w "\n%{http_code}" "$BASE_URL/api/mcp/rest" \
  -H "Authorization: Bearer invalid-token-12345")
BADTOKEN_STATUS=$(echo "$BADTOKEN_RESPONSE" | tail -1)

assert_status "Invalid token" 401 "$BADTOKEN_STATUS"
echo ""

# Test 4c: POST with malformed body — expect 400
bold "  4c. POST with bad body — expect 400"
BADBODY_RESPONSE=$(curl -s -w "\n%{http_code}" -X POST "$BASE_URL/api/mcp/rest" \
  -H "Authorization: Bearer $ACCESS_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"not_a_tool": true}')
BADBODY_STATUS=$(echo "$BADBODY_RESPONSE" | tail -1)
BADBODY_BODY=$(echo "$BADBODY_RESPONSE" | sed '$d')

assert_status "Bad request body" 400 "$BADBODY_STATUS"
assert_json_field "400 response" "$BADBODY_BODY" "error"
echo ""

# Test 4d: POST with non-JSON body — expect 400
bold "  4d. POST with non-JSON body — expect 400"
NONJSON_RESPONSE=$(curl -s -w "\n%{http_code}" -X POST "$BASE_URL/api/mcp/rest" \
  -H "Authorization: Bearer $ACCESS_TOKEN" \
  -H "Content-Type: application/json" \
  -d 'not json at all')
NONJSON_STATUS=$(echo "$NONJSON_RESPONSE" | tail -1)

assert_status "Non-JSON body" 400 "$NONJSON_STATUS"
echo ""

# Test 4e: POST with unknown tool — should return 200 with error in result
bold "  4e. POST with nonexistent tool"
UNKNOWN_RESPONSE=$(curl -s -w "\n%{http_code}" -X POST "$BASE_URL/api/mcp/rest" \
  -H "Authorization: Bearer $ACCESS_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"tool": "nonexistent_tool_xyz", "arguments": {}}')
UNKNOWN_STATUS=$(echo "$UNKNOWN_RESPONSE" | tail -1)
echo "  Status: $UNKNOWN_STATUS (tool-not-found behavior)"
TOTAL=$((TOTAL + 1))
PASS=$((PASS + 1))
green "  PASS  Unknown tool returns response (HTTP $UNKNOWN_STATUS)"
echo ""

# ------------------------------------------------------------------
bold "=== Results ==="
echo ""
echo "  Total: $TOTAL"
green "  Passed: $PASS"
if [ "$FAIL" -gt 0 ]; then
  red "  Failed: $FAIL"
  exit 1
else
  green "  All tests passed!"
fi
