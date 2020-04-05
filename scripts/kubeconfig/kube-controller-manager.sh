#!/usr/bin/env bash

set -eu

source "`pwd`/scripts/__helpers.sh"

kubectl config set-cluster $KUBECONFIG_CLUSTER_NAME \
  --certificate-authority=$PKI_DIR/ca.pem \
  --embed-certs=true \
  --server=https://127.0.0.1:${APISERVER_PORT} \
  --kubeconfig=$KUBECONFIG_DIR/kube-controller-manager.kubeconfig

kubectl config set-credentials system:kube-controller-manager \
  --client-certificate=$PKI_DIR/kube-controller-manager.pem \
  --client-key=$PKI_DIR/kube-controller-manager-key.pem \
  --embed-certs=true \
  --kubeconfig=$KUBECONFIG_DIR/kube-controller-manager.kubeconfig

kubectl config set-context default \
  --cluster=$KUBECONFIG_CLUSTER_NAME \
  --user=system:kube-controller-manager \
  --kubeconfig=$KUBECONFIG_DIR/kube-controller-manager.kubeconfig

kubectl config use-context default --kubeconfig=$KUBECONFIG_DIR/kube-controller-manager.kubeconfig
