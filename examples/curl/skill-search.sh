#!/bin/bash
# Search for skills by keyword
# Usage: AIDENT_TOKEN=... ./skill-search.sh "send email"

BASE_URL="${AIDENT_BASE_URL:-https://app.aident.ai}"
QUERY="${1:-send email}"

curl -s -X POST "$BASE_URL/api/mcp/rest" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $AIDENT_TOKEN" \
  -d "{
    \"tool\": \"skill_search\",
    \"arguments\": { \"query\": \"$QUERY\", \"limit\": 5 }
  }" | python3 -m json.tool
