# zfs-monitoring
[Simple bash script](https://github.com/OllieJC/home-network-public/blob/main/applications/zfs-monitoring/zfs-alert.sh) to monitor ZFS and post a message to Slack via a webhook.

Utilises `zpool status`.

## cron
``` bash
*/5 * * * * \
  SLACK_CHANNEL="zfs-monitoring" \
  SLACK_USERNAME="zfs-$HOSTNAME" \
  SLACK_WEBHOOK="https://hooks.slack.com/services/..." \
  /home/ollie/github/home-network-public/applications/zfs-monitoring/zfs-alert.sh
```
