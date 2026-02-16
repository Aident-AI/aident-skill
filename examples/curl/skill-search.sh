#!/bin/bash
# Search for skills by keyword
# Usage: AIDENT_TOKEN=... ./skill-search.sh "send email"

QUERY="${1:-send email}"

curl -s -X POST https://app.aident.ai/api/mcp/rest \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $AIDENT_TOKEN" \
  -d "{
    \"tool\": \"skill_search\",
    \"arguments\": { \"query\": \"$QUERY\", \"limit\": 5 }
  }" | python3 -m json.tool
