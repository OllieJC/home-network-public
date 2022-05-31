#!/usr/bin/env bash

set -e

# SLACK_WEBHOOK
# SLACK_CHANNEL
# SLACK_USERNAME

SCRIPT_FOLDER=$(echo "${BASH_SOURCE[0]}" | grep -Po "^.*\/")
LES_FILE="$SCRIPT_FOLDER.last-error-state.txt"
LAST_ERROR_STATE=$(if [[ -f "$LES_FILE" ]]; then cat "$LES_FILE"; else echo 0; fi | tr -d "\n")

STATUS=$(zpool status)

if [ ${#STATUS} -le 1 ]; then
  STATUS="Empty - maybe the hard drives aren't mounted?"
fi

## Testing:
#read -r -d '' STATUS << EOM
#pool: hdd_data
# state: ONLINE
#  scan: scrub repaired 1B in 00:25:38 with 0 errors on Sun Apr 10 00:49:39 2022
#config:
#
#        NAME                        STATE     READ WRITE CKSUM
#        hdd_data                    ONLINE       0     0     0
#          raidz1-0                  ONLINE       0     0     0
#            wwn-0x1  ONLINE       0     0     0
#            wwn-0x2  DEGRADED       0     0     0
#            wwn-0x3  ONLINE       0     0     0
#            wwn-0x4  ONLINE       0     0     0
#
#errors: No known data errors
#EOM

IS_ERROR_STATE=0

if echo "$STATUS" | grep -qPo "scan:.+?with\s[1-9]+\d*\serror"; then
  IS_ERROR_STATE=1
fi

if echo "$STATUS" | grep -qPo "DEGRADED"; then
  IS_ERROR_STATE=1
fi

if echo "$STATUS" | grep -qPo "errors: No known data errors"; then
  echo "No known data errors detected."
else
  IS_ERROR_STATE=1
fi

echo "Current error state: $IS_ERROR_STATE"
if [ "$IS_ERROR_STATE" -ne "$LAST_ERROR_STATE" ]; then
  echo "Error state has changed, sending notification."
  if [ "$IS_ERROR_STATE" -eq 1 ]; then
    echo "Sending bad notification..."
    curl -X POST --data-urlencode "payload={\"channel\": \"#$SLACK_CHANNEL\", \"username\": \"$SLACK_USERNAME\", \"text\": \"Oh no. There's a problem with ZFS on *${HOSTNAME}*.\n\`\`\`${STATUS}\`\`\`\", \"icon_emoji\": \":sob:\"}" "$SLACK_WEBHOOK"
  else
    echo "Sending good notification..."
    curl -X POST --data-urlencode "payload={\"channel\": \"#$SLACK_CHANNEL\", \"username\": \"$SLACK_USERNAME\", \"text\": \"ZFS on *${HOSTNAME}* is happy.\n\`\`\`${STATUS}\`\`\`\", \"icon_emoji\": \":smiley:\"}" "$SLACK_WEBHOOK"
  fi
fi

echo "$IS_ERROR_STATE" > "$LES_FILE"
