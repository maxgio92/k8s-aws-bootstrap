#!/usr/bin/env bash

set -eu

source "`pwd`/scripts/__helpers.sh"

echo -n "Uploading master certificates and keys..."

n=0
while [ "$n" -lt "$MASTERS_COUNT" ]; do
  MASTER_PUBLIC_IP=`echo $MASTERS_PUBLIC_IPS | jq ".[${n}]" | tr -d '"'`
  MASTER_PRIVATE_IP=`echo $MASTERS_PRIVATE_IPS | jq ".[${n}]" | tr -d '"'`

  scp -oStrictHostKeyChecking=no -q \
      $PKI_DIR/ca.pem $PKI_DIR/ca-key.pem \
      $PKI_DIR/kubernetes-key.pem $PKI_DIR/kubernetes.pem \
      $PKI_DIR/service-account-key.pem $PKI_DIR/service-account.pem \
      $USER@$MASTER_PUBLIC_IP:~/ 
  n=$(( n+1 ))
done

echo "Done."

echo -n "Uploading worker certificates and keys..."

n=0
while [ "$n" -lt "$WORKERS_COUNT" ]; do
  WORKER_PUBLIC_IP=`echo $WORKERS_PUBLIC_IPS | jq ".[${n}]" | tr -d '"'`
  WORKER_PRIVATE_IP=`echo $WORKERS_PRIVATE_IPS | jq ".[${n}]" | tr -d '"'`

  scp -oStrictHostKeyChecking=no -q \
      $PKI_DIR/ca.pem \
      $PKI_DIR/worker-$n-key.pem \
      $USER@$WORKER_PUBLIC_IP:~/ 
  n=$(( n+1 ))
done

echo "Done."
