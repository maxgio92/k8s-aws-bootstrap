#!/usr/bin/env bash

set -eu

source "`pwd`/scripts/__helpers.sh"

echo -n "Configure and start kubelet on worker nodes..."

n=0
while [ "$n" -lt "$WORKERS_COUNT" ]; do
  WORKER_PUBLIC_IP=`echo $WORKERS_PUBLIC_IPS | jq ".[${n}]" | tr -d '"'`
  
  scp -oStrictHostKeyChecking=no -q \
      `pwd`/scripts/worker/kubelet/configure.sh \
      $USER@$WORKER_PUBLIC_IP:configure-kubelet.sh
  ssh -oStrictHostKeyChecking=no -q \
      $USER@$WORKER_PUBLIC_IP \
      ./configure-kubelet.sh $n
  ssh -oStrictHostKeyChecking=no -q \
      $USER@$WORKER_PUBLIC_IP \
      sudo systemctl start kubelet
  ssh -oStrictHostKeyChecking=no -q \
      $USER@$WORKER_PUBLIC_IP \
      sudo systemctl status kubelet

  n=$(( n+1 ))
done

echo "Done."
