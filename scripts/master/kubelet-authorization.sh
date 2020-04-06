#!/usr/bin/env bash

set -eu

source "`pwd`/scripts/__helpers.sh"

echo -n "Configure kube-apiserver user's permissions to access the kubelet APIs..."

MASTER_PUBLIC_IP=`echo $MASTERS_PUBLIC_IPS | jq ".[0]" | tr -d '"'`

scp -oStrictHostKeyChecking=no -q \
  `pwd`/scripts/master/kubelet-authorization/configure.sh \
  $USER@$MASTER_PUBLIC_IP:configure-kubelet-authorization.sh
ssh -oStrictHostKeyChecking=no -q \
  $USER@$MASTER_PUBLIC_IP \
  ./configure-kubelet-authorization.sh

echo "Done."
