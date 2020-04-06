#!/usr/bin/env bash

set -eu

source "`pwd`/scripts/__helpers.sh"

echo -n "Configure CNI network plugin on worker nodes..."

n=0
while [ "$n" -lt "$WORKERS_COUNT" ]; do
  WORKER_PUBLIC_IP=`echo $WORKERS_PUBLIC_IPS | jq ".[${n}]" | tr -d '"'`
  
  scp -oStrictHostKeyChecking=no -q \
      `pwd`/scripts/worker/cni/configure.sh \
      $USER@$WORKER_PUBLIC_IP:configure-cni.sh
  ssh -oStrictHostKeyChecking=no -q \
      $USER@$WORKER_PUBLIC_IP \
      ./configure-cni.sh $n

  n=$(( n+1 ))
done

echo "Done."
