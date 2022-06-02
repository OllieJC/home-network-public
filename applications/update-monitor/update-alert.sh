#!/usr/bin/env bash

set -e

# SLACK_WEBHOOK
# SLACK_CHANNEL
# SLACK_USERNAME

UPGRADES=$(apt list --upgradable | grep "upgradable")

if echo "$UPGRADES" | grep -qPo "upgradable"; then
  PACKAGES=""
  COUNT=0
  while IFS= read -r line; do
    PACKAGES+=$(echo "$line" | grep -oP ".*\/" | tr -d "\/")
    PACKAGES+=", "
    COUNT=$(( COUNT + 1 ))
  done <<< "$UPGRADES"
  PACKAGES=$(echo "$PACKAGES" | rev | cut -c 3- | rev)

  IS_OR_ARE="are"
  PATCH_OR_PATCHES="patches"
  if [ "$COUNT" -eq 1 ]; then
    IS_OR_ARE="is"
    PATCH_OR_PATCHES="patch"
  fi

  echo "Has upgrades: 1"
  echo "Sending upgrade notification..."
  curl -X POST --data-urlencode "payload={\"channel\": \"#$SLACK_CHANNEL\", \"username\": \"$SLACK_USERNAME\", \"text\": \"There ${IS_OR_ARE} *${COUNT}* ${PATCH_OR_PATCHES} available for *${HOSTNAME}*:\n\`\`\`${PACKAGES}\`\`\`\", \"icon_emoji\": \":shield:\"}" "$SLACK_WEBHOOK"
else
  echo "Has upgrades: 0"
fi
