#!/bin/bash
# List connected Loadout Vault integrations
# Usage: AIDENT_TOKEN=... ./vault.sh

BASE_URL="${AIDENT_BASE_URL:-https://loadout.aident.ai}"

curl -s -X POST "$BASE_URL/api/openapi/loadout/loadout_vault" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $AIDENT_TOKEN" \
  -d '{"action":"status"}' | python3 -m json.tool
echo ""
