#!/bin/bash
# List your playbooks
# Usage: AIDENT_TOKEN=... ./playbook-list.sh

curl -s -X POST https://app.aident.ai/api/mcp/rest \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $AIDENT_TOKEN" \
  -d '{ "tool": "playbook_list", "arguments": {} }' | python3 -m json.tool
