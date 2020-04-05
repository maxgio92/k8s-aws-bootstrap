#!/usr/bin/env bash

set -eu

source "`pwd`/scripts/__helpers.sh"

n=0
while [ "$n" -lt "$MASTERS_COUNT" ]; do
  MASTER_PUBLIC_IP=`echo $MASTERS_PUBLIC_IPS | jq ".[${n}]" | tr -d '"'`
  MASTER_PRIVATE_IP=`echo $MASTERS_PRIVATE_IPS | jq ".[${n}]" | tr -d '"'`

  echo "*** Copy certs to master node ${n}"
  scp -oStrictHostKeyChecking=no $PKI_DIR/ca.pem $PKI_DIR/ca-key.pem $PKI_DIR/kubernetes-key.pem $PKI_DIR/kubernetes.pem $PKI_DIR/service-account-key.pem $PKI_DIR/service-account.pem $USER@$MASTER_PUBLIC_IP:~/ 
  n=$(( n+1 ))
done

n=0
while [ "$n" -lt "$WORKERS_COUNT" ]; do
  WORKER_PUBLIC_IP=`echo $WORKERS_PUBLIC_IPS | jq ".[${n}]" | tr -d '"'`
  WORKER_PRIVATE_IP=`echo $WORKERS_PRIVATE_IPS | jq ".[${n}]" | tr -d '"'`

  echo "*** Copy certs to worker nodes"
  scp -oStrictHostKeyChecking=no $PKI_DIR/ca.pem $PKI_DIR/worker-$n-key.pem $USER@$WORKER_PUBLIC_IP:~/ 
  n=$(( n+1 ))
done
