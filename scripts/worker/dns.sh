#!/usr/bin/env bash

set -eu

source "`pwd`/scripts/__helpers.sh"

echo -n "Configure CoreDNS addon in the cluster..."

MASTER_PUBLIC_IP=`echo $MASTERS_PUBLIC_IPS | jq ".[0]" | tr -d '"'`

scp -oStrictHostKeyChecking=no -q \
  `pwd`/scripts/worker/dns/configure.sh \
  $USER@$MASTER_PUBLIC_IP:configure-dns.sh
ssh -oStrictHostKeyChecking=no -q \
  $USER@$MASTER_PUBLIC_IP \
  ./configure-dns.sh

echo "Done."
