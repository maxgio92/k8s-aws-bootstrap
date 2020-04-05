#!/usr/bin/env bash

set -eu

source "`pwd`/scripts/__helpers.sh"

kubectl config set-cluster $KUBECONFIG_CLUSTER_NAME \
  --certificate-authority=$PKI_DIR/ca.pem \
  --embed-certs=true \
  --server=https://${MASTER_PUBLIC_IP}:${APISERVER_PORT} \
  --kubeconfig=$KUBECONFIG_DIR/kube-proxy.kubeconfig

kubectl config set-credentials system:kube-proxy \
  --client-certificate=$PKI_DIR/kube-proxy.pem \
  --client-key=$PKI_DIR/kube-proxy-key.pem \
  --embed-certs=true \
  --kubeconfig=$KUBECONFIG_DIR/kube-proxy.kubeconfig

kubectl config set-context default \
  --cluster=$KUBECONFIG_CLUSTER_NAME \
  --user=system:kube-proxy \
  --kubeconfig=$KUBECONFIG_DIR/kube-proxy.kubeconfig

kubectl config use-context default --kubeconfig=$KUBECONFIG_DIR/kube-proxy.kubeconfig
