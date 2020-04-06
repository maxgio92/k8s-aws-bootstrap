#!/usr/bin/env bash

set -eu

source "`pwd`/scripts/__helpers.sh"

echo -n "Download kubectl on master nodes..."

n=0
while [ "$n" -lt "$MASTERS_COUNT" ]; do
  MASTER_PUBLIC_IP=`echo $MASTERS_PUBLIC_IPS | jq ".[${n}]" | tr -d '"'`

  scp -oStrictHostKeyChecking=no -q \
      `pwd`/scripts/common/kubectl/download.sh \
      $USER@$MASTER_PUBLIC_IP:download-kubectl.sh
  ssh -oStrictHostKeyChecking=no -q \
      $USER@$MASTER_PUBLIC_IP \
      ./download-kubectl.sh

  n=$(( n+1 ))
done

echo "Done."

echo -n "Download kubectl on worker nodes..."

n=0
while [ "$n" -lt "$WORKERS_COUNT" ]; do
  WORKER_PUBLIC_IP=`echo $WORKERS_PUBLIC_IPS | jq ".[${n}]" | tr -d '"'`

  scp -oStrictHostKeyChecking=no -q \
      `pwd`/scripts/common/kubectl/download.sh \
      $USER@$WORKER_PUBLIC_IP:download-kubectl.sh
  ssh -oStrictHostKeyChecking=no -q \
      $USER@$WORKER_PUBLIC_IP \
      ./download-kubectl.sh

  n=$(( n+1 ))
done

echo "Done."
