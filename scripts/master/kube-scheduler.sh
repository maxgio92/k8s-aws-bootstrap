#!/usr/bin/env bash

set -eu

source "`pwd`/scripts/__helpers.sh"

echo -n "Configure and start kube-scheduler on master nodes..."

n=0
while [ "$n" -lt "$MASTERS_COUNT" ]; do
  MASTER_PUBLIC_IP=`echo $MASTERS_PUBLIC_IPS | jq ".[${n}]" | tr -d '"'`

  scp -oStrictHostKeyChecking=no -q \
      `pwd`/scripts/master/kube-scheduler/configure.sh \
      $USER@$MASTER_PUBLIC_IP:configure-kube-scheduler.sh
  ssh -oStrictHostKeyChecking=no -q \
      $USER@$MASTER_PUBLIC_IP \
      ./configure-kube-scheduler.sh
  ssh -oStrictHostKeyChecking=no -q \
      $USER@$MASTER_PUBLIC_IP \
      sudo systemctl start kube-scheduler
  ssh -oStrictHostKeyChecking=no -q \
      $USER@$MASTER_PUBLIC_IP \
      sudo systemctl status kube-scheduler

  n=$(( n+1 ))
done

echo "Done."
