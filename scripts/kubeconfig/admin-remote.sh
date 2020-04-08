#!/usr/bin/env bash

set -eu

source "`pwd`/scripts/__helpers.sh"

MASTER_PUBLIC_IP=`echo $MASTERS_PUBLIC_IPS | jq ".[0]" | tr -d '"'`

cp $KUBECONFIG_DIR/admin.kubeconfig $KUBECONFIG_DIR/admin-remote.kubeconfig
sed -i "s/127.0.0.1/${MASTER_PUBLIC_IP}/g" $KUBECONFIG_DIR/admin-remote.kubeconfig
