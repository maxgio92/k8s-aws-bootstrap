#!/usr/bin/env bash

set -eu

source "`pwd`/scripts/__helpers.sh"

n=0
while [ "$n" -lt "$WORKERS_COUNT" ]; do
  WORKER_NAME=`echo $WORKERS_PRIVATE_DNS | jq ".[${n}]" | tr -d '"'`

  kubectl config set-cluster $KUBECONFIG_CLUSTER_NAME \
    --certificate-authority=$PKI_DIR/ca.pem \
    --embed-certs=true \
    --server=https://${MASTER_PUBLIC_IP}:${APISERVER_PORT} \
    --kubeconfig=$KUBECONFIG_DIR/${WORKER_NAME}.kubeconfig
  
  kubectl config set-credentials system:node:${WORKER_NAME} \
    --client-certificate=$PKI_DIR/${WORKER_NAME}.pem \
    --client-key=$PKI_DIR/${WORKER_NAME}-key.pem \
    --embed-certs=true \
    --kubeconfig=$KUBECONFIG_DIR/${WORKER_NAME}.kubeconfig
  
  kubectl config set-context default \
    --cluster=$KUBECONFIG_CLUSTER_NAME \
    --user=system:node:${WORKER_NAME} \
    --kubeconfig=$KUBECONFIG_DIR/${WORKER_NAME}.kubeconfig
  
  kubectl config use-context default --kubeconfig=$KUBECONFIG_DIR/${WORKER_NAME}.kubeconfig
  
  n=$(( n+1 ))
done
