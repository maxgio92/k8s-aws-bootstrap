#!/usr/bin/env bash

set -eu

source "`pwd`/scripts/__helpers.sh"

echo -n "Configure Weavenet CNI network plugin..."

MASTER_PUBLIC_IP=`echo $MASTERS_PUBLIC_IPS | jq ".[0]" | tr -d '"'`

scp -oStrictHostKeyChecking=no -q \
  `pwd`/scripts/worker/weavenet/configure.sh \
  $USER@$MASTER_PUBLIC_IP:configure-weavenet.sh
ssh -oStrictHostKeyChecking=no -q \
  $USER@$MASTER_PUBLIC_IP \
  ./configure-weavenet.sh "${POD_CIDR}"
echo "Done."
