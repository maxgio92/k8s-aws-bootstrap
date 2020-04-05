#!/usr/bin/env bash

set -eu

source "`pwd`/scripts/__helpers.sh"

kubectl config set-cluster $KUBECONFIG_CLUSTER_NAME \
  --certificate-authority=$PKI_DIR/ca.pem \
  --embed-certs=true \
  --server=https://127.0.0.1:${APISERVER_PORT} \
  --kubeconfig=$KUBECONFIG_DIR/admin.kubeconfig

kubectl config set-credentials admin \
  --client-certificate=$PKI_DIR/admin.pem \
  --client-key=$PKI_DIR/admin-key.pem \
  --embed-certs=true \
  --kubeconfig=$KUBECONFIG_DIR/admin.kubeconfig

kubectl config set-context default \
  --cluster=$KUBECONFIG_CLUSTER_NAME \
  --user=admin \
  --kubeconfig=$KUBECONFIG_DIR/admin.kubeconfig

kubectl config use-context default --kubeconfig=$KUBECONFIG_DIR/admin.kubeconfig
