#!/usr/bin/env bash

set -eu

source "`pwd`/scripts/__helpers.sh"

cat > $PKI_DIR/admin-csr.json <<EOF
{
  "CN": "admin",
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "IT",
      "L": "Fano",
      "O": "system:masters",
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
  $PKI_DIR/admin-csr.json | cfssljson -bare $PKI_DIR/admin
