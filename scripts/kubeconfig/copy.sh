#!/usr/bin/env bash

set -eu

source "`pwd`/scripts/__helpers.sh"

echo -n "Uploading master kubeconfig..."

n=0
while [ "$n" -lt "$MASTERS_COUNT" ]; do
  MASTER_PUBLIC_IP=`echo $MASTERS_PUBLIC_IPS | jq ".[${n}]" | tr -d '"'`

  scp -oStrictHostKeyChecking=no -q \
      $KUBECONFIG_DIR/admin.kubeconfig \
      $KUBECONFIG_DIR/kube-controller-manager.kubeconfig \
      $KUBECONFIG_DIR/kube-scheduler.kubeconfig \
      ${USER}@${MASTER_PUBLIC_IP}:~/ 
  n=$(( n+1 ))
done

echo "Done."

echo -n "Uploading worker kubeconfig..."

n=0
while [ "$n" -lt "$WORKERS_COUNT" ]; do
  WORKER_PUBLIC_IP=`echo $WORKERS_PUBLIC_IPS | jq ".[${n}]" | tr -d '"'`
  WORKER_NAME=`echo $WORKERS_PRIVATE_DNS | jq ".[${n}]" | tr -d '"'`

  scp -oStrictHostKeyChecking=no -q \
      ${KUBECONFIG_DIR}/${WORKER_NAME}.kubeconfig \
      $KUBECONFIG_DIR/kube-proxy.kubeconfig \
      ${USER}@${WORKER_PUBLIC_IP}:~/ 
  n=$(( n+1 ))
done

echo "Done."
