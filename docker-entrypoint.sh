#!/usr/bin/env sh
set -e

exec "$@"
exit 0

crontab=/var/spool/cron/crontabs/root

>$crontab

echo "==> Add crontab         CRON_SCHEDULE: $CRON_SCHEDULE"

if [ -n "$CRON_SCHEDULE" ]; then
  echo "$CRON_SCHEDULE sync.sh" >> $crontab
fi

if [[ "$1" =~ ^[0-9*] ]]; then
  while test $# -gt 0; do
    echo "$1" >> $crontab
    shift
  done
fi

if [ -f /etc/crontab ]; then
  cat /etc/crontab >> $crontab
fi

if [ -s "${crontab}" ]; then
  set -- crond -f -L /dev/stdout -l 8
fi

start_date=$(date +'%Y-%m-%d %H:%M:%S')
echo "==> File: $crontab"
cat $crontab
echo

echo "==> Start sync: ${start_date}"
exec "$@"
