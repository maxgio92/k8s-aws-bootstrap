#!/usr/bin/env bash

set -e

PKI_DIR=./data/pki

cat > $PKI_DIR/ca-config.json <<EOF
{
  "signing": {
    "default": {
      "expiry": "8760h"
    },
    "profiles": {
      "kubernetes": {
        "usages": ["signing", "key encipherment", "server auth", "client auth"],
        "expiry": "8760h"
      }
    }
  }
}
EOF

cat > $PKI_DIR/ca-csr.json <<EOF
{
  "CN": "Kubernetes",
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "IT",
      "L": "Fano",
      "O": "Kubernetes",
      "OU": "CA",
      "ST": "Italy"
    }
  ]
}
EOF

cfssl gencert -initca $PKI_DIR/ca-csr.json | cfssljson -bare $PKI_DIR/ca
