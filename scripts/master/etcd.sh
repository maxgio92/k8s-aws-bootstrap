#!/usr/bin/env bash

set -eu

source "`pwd`/scripts/__helpers.sh"

echo -n "Configure and start etcd server on master nodes..."

n=0
while [ "$n" -lt "$MASTERS_COUNT" ]; do
  MASTER_PUBLIC_IP=`echo $MASTERS_PUBLIC_IPS | jq ".[${n}]" | tr -d '"'`
  MASTER_PRIVATE_IP=`echo $MASTERS_PRIVATE_IPS | jq ".[${n}]" | tr -d '"'`

  scp -oStrictHostKeyChecking=no -q \
      `pwd`/scripts/master/configure-etcd.sh \
      $USER@$MASTER_PUBLIC_IP:
  ssh -oStrictHostKeyChecking=no -q \
      $USER@$MASTER_PUBLIC_IP \
      ./configure-etcd.sh
  ssh -oStrictHostKeyChecking=no -q \
      $USER@$MASTER_PUBLIC_IP \
      sudo systemctl start etcd
  ssh -oStrictHostKeyChecking=no -q \
      $USER@$MASTER_PUBLIC_IP \
      sudo systemctl status etcd

  n=$(( n+1 ))
done

echo "Done."
