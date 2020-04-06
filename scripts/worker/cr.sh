#!/usr/bin/env bash

set -eu

source "`pwd`/scripts/__helpers.sh"

echo -n "Configure and start CR on worker nodes..."

n=0
while [ "$n" -lt "$WORKERS_COUNT" ]; do
  WORKER_PUBLIC_IP=`echo $WORKERS_PUBLIC_IPS | jq ".[${n}]" | tr -d '"'`
  
  scp -oStrictHostKeyChecking=no -q \
      `pwd`/scripts/worker/cr/configure.sh \
      $USER@$WORKER_PUBLIC_IP:configure-cr.sh
  ssh -oStrictHostKeyChecking=no -q \
      $USER@$WORKER_PUBLIC_IP \
      ./configure-cr.sh
  ssh -oStrictHostKeyChecking=no -q \
      $USER@$WORKER_PUBLIC_IP \
      sudo systemctl start containerd
  ssh -oStrictHostKeyChecking=no -q \
      $USER@$WORKER_PUBLIC_IP \
      sudo systemctl status containerd

  n=$(( n+1 ))
done

echo "Done."
