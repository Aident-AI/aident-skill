#!/bin/bash
# Execute a skill by name
# Usage: AIDENT_TOKEN=... ./skill-execute.sh gmail_send_email '{"to":"user@example.com","subject":"Hello","body":"World"}'

BASE_URL="${AIDENT_BASE_URL:-https://app.aident.ai}"
SKILL_NAME="${1:?Usage: ./skill-execute.sh <skill_name> <input_json>}"
INPUT_JSON="${2:?Usage: ./skill-execute.sh <skill_name> <input_json>}"

curl -s -X POST "$BASE_URL/api/mcp/rest" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $AIDENT_TOKEN" \
  -d "{
    \"tool\": \"skill_execute\",
    \"arguments\": {
      \"skillName\": \"$SKILL_NAME\",
      \"input\": $INPUT_JSON
    }
  }" | python3 -m json.tool
