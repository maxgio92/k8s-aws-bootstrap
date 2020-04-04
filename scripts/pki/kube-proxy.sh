#!/usr/bin/env bash

set -e

PKI_DIR=./data/pki

cat > $PKI_DIR/kube-proxy-csr.json <<EOF
{
  "CN": "system:kube-proxy",
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "IT",
      "L": "Fano",
      "O": "system:node-proxier",
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
  $PKI_DIR/kube-proxy-csr.json | cfssljson -bare $PKI_DIR/kube-proxy
