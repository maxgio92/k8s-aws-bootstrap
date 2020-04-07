#!/usr/bin/env bash

set -eu

kubectl --kubeconfig admin.kubeconfig apply -f https://storage.googleapis.com/kubernetes-the-hard-way/coredns.yaml
