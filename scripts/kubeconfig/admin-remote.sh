#!/usr/bin/env bash

set -eu

source "`pwd`/scripts/__helpers.sh"

MASTER_PUBLIC_IP=`echo $MASTERS_PUBLIC_IPS | jq ".[0]" | tr -d '"'`

kubectl config set-cluster $KUBECONFIG_CLUSTER_NAME \
  --certificate-authority=$PKI_DIR/ca.pem \
  --embed-certs=true \
  --server=https://${MASTER_PUBLIC_IP}:${APISERVER_PORT} \
  --kubeconfig=$KUBECONFIG_DIR/admin-remote.kubeconfig

kubectl config set-credentials admin \
  --client-certificate=$PKI_DIR/admin.pem \
  --client-key=$PKI_DIR/admin-key.pem \
  --embed-certs=true \
  --kubeconfig=$KUBECONFIG_DIR/admin-remote.kubeconfig

kubectl config set-context default \
  --cluster=$KUBECONFIG_CLUSTER_NAME \
  --user=admin \
  --kubeconfig=$KUBECONFIG_DIR/admin-remote.kubeconfig

kubectl config use-context default --kubeconfig=$KUBECONFIG_DIR/admin-remote.kubeconfig
