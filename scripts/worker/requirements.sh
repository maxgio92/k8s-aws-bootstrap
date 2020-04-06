#!/usr/bin/env bash

set -eu

source "`pwd`/scripts/__helpers.sh"

echo -n "Configure the requirements on worker nodes..."

n=0
while [ "$n" -lt "$WORKERS_COUNT" ]; do
  WORKER_PUBLIC_IP=`echo $WORKERS_PUBLIC_IPS | jq ".[${n}]" | tr -d '"'`

  scp -oStrictHostKeyChecking=no -q \
      `pwd`/scripts/worker/requirements/configure.sh \
      $USER@$WORKER_PUBLIC_IP:configure-requirements.sh
  ssh -oStrictHostKeyChecking=no -q \
      $USER@$WORKER_PUBLIC_IP \
      ./configure-requirements.sh

  n=$(( n+1 ))
done

echo "Done."
