#!/bin/bash
[[ $(whoami) != "root" ]] && SUDO=sudo

$SUDO mkdir -p /cron /cron-log
$SUDO touch /cron/default
$SUDO cat /cron/* | $SUDO crontab -
$SUDO cron

export DOCKER_ENTRYPOINT=1
source /.bashrc
echo "Current time: $(date)"

exec "$@"