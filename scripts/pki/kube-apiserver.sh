#!/usr/bin/env bash

set -eu

source "`pwd`/scripts/pki/__helpers.sh"

MASTERS_PUBLIC_IPS_VARNAME=cluster_master_nodes_public_ips
MASTERS_PRIVATE_IPS_VARNAME=cluster_master_nodes_private_ips
MASTERS_COUNT_VARNAME=cluster_master_size
MASTERS_PUBLIC_IPS=`cd ./iac && $TERRAFORM_BIN output -json -no-color $MASTERS_PUBLIC_IPS_VARNAME`
MASTERS_PRIVATE_IPS=`cd ./iac && $TERRAFORM_BIN output -json -no-color $MASTERS_PRIVATE_IPS_VARNAME`
MASTERS_COUNT=`cd ./iac && $TERRAFORM_BIN output -json -no-color $MASTERS_COUNT_VARNAME`
KUBERNETES_HOSTNAMES=kubernetes,kubernetes.default,kubernetes.default.svc,kubernetes.default.svc.cluster,kubernetes.svc.cluster.local

MASTERS_PUBLIC_IPS=${MASTERS_PUBLIC_IPS//[}
MASTERS_PUBLIC_IPS=${MASTERS_PUBLIC_IPS//]}
MASTERS_PUBLIC_IPS=${MASTERS_PUBLIC_IPS//\"}
MASTERS_PRIVATE_IPS=${MASTERS_PRIVATE_IPS//[}
MASTERS_PRIVATE_IPS=${MASTERS_PRIVATE_IPS//]}
MASTERS_PRIVATE_IPS=${MASTERS_PRIVATE_IPS//\"}

cat > $PKI_DIR/kubernetes-csr.json <<EOF
{
  "CN": "kubernetes",
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "US",
      "L": "Portland",
      "O": "Kubernetes",
      "OU": "Kubernetes The Hard Way",
      "ST": "Oregon"
    }
  ]
}
EOF

cfssl gencert \
  -ca=$PKI_DIR/ca.pem \
  -ca-key=$PKI_DIR/ca-key.pem \
  -config=$PKI_DIR/ca-config.json \
  -hostname=10.32.0.1,${MASTERS_PRIVATE_IPS},${MASTERS_PUBLIC_IPS},127.0.0.1,${KUBERNETES_HOSTNAMES} \
  -profile=kubernetes \
  $PKI_DIR/kubernetes-csr.json | cfssljson -bare $PKI_DIR/kubernetes
