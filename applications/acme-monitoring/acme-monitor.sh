#!/usr/bin/env bash

SLACK_USERNAME="ACME-${HOSTNAME}"
export SLACK_USERNAME

if [ "$(find "${CERT_PATH}" -cmin +"${CERT_MINS}")" ]; then
  echo "File older than ${CERT_MINS} minutes, sending Slack notification..."
  curl -X POST --data-urlencode "payload={\"channel\": \"#$SLACK_CHANNEL\", \"username\": \"$SLACK_USERNAME\", \"text\": \"Oh no. It looks like the certificate (\`${CERT_PATH}\`) on *${HOSTNAME}* hasn't been rotated.\", \"icon_emoji\": \":sob:\"}" "$SLACK_WEBHOOK"
else
  echo "Certificate (${CERT_PATH}) appears in date!"
fi
