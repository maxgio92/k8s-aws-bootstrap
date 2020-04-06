#!/usr/bin/env bash

set -eu

source "`pwd`/scripts/__helpers.sh"

echo -n "Configure and start kube-controller-manager on master nodes..."

n=0
while [ "$n" -lt "$MASTERS_COUNT" ]; do
  MASTER_PUBLIC_IP=`echo $MASTERS_PUBLIC_IPS | jq ".[${n}]" | tr -d '"'`

  scp -oStrictHostKeyChecking=no -q \
      `pwd`/scripts/master/kube-controller-manager/configure.sh \
      $USER@$MASTER_PUBLIC_IP:configure-kube-controller-manager.sh
  ssh -oStrictHostKeyChecking=no -q \
      $USER@$MASTER_PUBLIC_IP \
      ./configure-kube-controller-manager.sh
  ssh -oStrictHostKeyChecking=no -q \
      $USER@$MASTER_PUBLIC_IP \
      sudo systemctl start kube-controller-manager
  ssh -oStrictHostKeyChecking=no -q \
      $USER@$MASTER_PUBLIC_IP \
      sudo systemctl status kube-controller-manager

  n=$(( n+1 ))
done

echo "Done."
