#!/usr/bin/env bash

set -e

PKI_DIR=./data/pki
TERRAFORM_BIN=terraform
WORKERS_PUBLIC_IPS_VARNAME=cluster_worker_nodes_public_ips
WORKERS_PRIVATE_IPS_VARNAME=cluster_worker_nodes_private_ips
WORKERS_COUNT_VARNAME=cluster_worker_size
WORKERS_PUBLIC_IPS=`cd ./iac && $TERRAFORM_BIN output -json -no-color $WORKERS_PUBLIC_IPS_VARNAME`
WORKERS_PRIVATE_IPS=`cd ./iac && $TERRAFORM_BIN output -json -no-color $WORKERS_PRIVATE_IPS_VARNAME`
WORKERS_COUNT=`cd ./iac && $TERRAFORM_BIN output -json -no-color $WORKERS_COUNT_VARNAME`

n=0
while [ "$n" -lt "$WORKERS_COUNT" ]; do
  WORKER_NAME="worker-${n}"
  WORKER_PUBLIC_IP=`echo $WORKERS_PUBLIC_IPS | jq ".[${n}]" | tr -d '"'`
  WORKER_PRIVATE_IP=`echo $WORKERS_PRIVATE_IPS | jq ".[${n}]" | tr -d '"'`

  echo $WORKER_NAME
  echo $WORKER_PUBLIC_IP
  echo $WORKER_PRIVATE_IP

  cat > $PKI_DIR/${WORKER_NAME}-csr.json <<EOF
{
  "CN": "system:node:${WORKER_NAME}",
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "IT",
      "L": "Fano",
      "O": "system:nodes",
      "OU": "k8s-aws-bootstrap",
      "ST": "Italy"
    }
  ]
}
EOF

  cfssl gencert \
    -ca=$PKI_DIR/ca.pem \
    -ca-key=$PKI_DIR/ca-key.pem \
    -config=$PKI_DIR/ca-config.json \
    -hostname=${WORKER_NAME},${WORKER_PUBLIC_IP},${WORKER_PRIVATE_IP} \
    -profile=kubernetes \
    $PKI_DIR/${WORKER_NAME}-csr.json | cfssljson -bare $PKI_DIR/${WORKER_NAME}

  n=$(( n+1 ))
done
