#!/usr/bin/env bash

set -eu

source "`pwd`/scripts/__helpers.sh"

echo -n "Configure and start kube-proxy on worker nodes..."

n=0
while [ "$n" -lt "$WORKERS_COUNT" ]; do
  WORKER_PUBLIC_IP=`echo $WORKERS_PUBLIC_IPS | jq ".[${n}]" | tr -d '"'`
  
  scp -oStrictHostKeyChecking=no -q \
      `pwd`/scripts/worker/kube-proxy/configure.sh \
      $USER@$WORKER_PUBLIC_IP:configure-kube-proxy.sh
  ssh -oStrictHostKeyChecking=no -q \
      $USER@$WORKER_PUBLIC_IP \
      ./configure-kube-proxy.sh $n
  ssh -oStrictHostKeyChecking=no -q \
      $USER@$WORKER_PUBLIC_IP \
      sudo systemctl start kube-proxy
  ssh -oStrictHostKeyChecking=no -q \
      $USER@$WORKER_PUBLIC_IP \
      sudo systemctl status kube-proxy

  n=$(( n+1 ))
done

echo "Done."
