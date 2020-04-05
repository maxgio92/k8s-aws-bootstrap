#!/usr/bin/env bash

set -e

source "`pwd`/scripts/pki/__helpers.sh"

cat > $PKI_DIR/kube-controller-manager-csr.json <<EOF
{
  "CN": "system:kube-controller-manager",
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "IT",
      "L": "Fano",
      "O": "system:kube-controller-manager",
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
  -profile=kubernetes \
  $PKI_DIR/kube-controller-manager-csr.json | cfssljson -bare $PKI_DIR/kube-controller-manager

