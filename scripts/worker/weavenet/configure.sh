#!/usr/bin/env bash

set -eu

POD_CIDR=$1

kubectl --kubeconfig admin.kubeconfig apply -f "https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d '\n')&env.IPALLOC_RANGE=${POD_CIDR}"
