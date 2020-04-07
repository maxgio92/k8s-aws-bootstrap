#!/usr/bin/env bash

set -eu

source "`pwd`/scripts/__helpers.sh"

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
      "C": "IT",
      "L": "Fano",
      "O": "Kubernetes",
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
  -hostname=10.32.0.1,${MASTERS_PRIVATE_IPS},${MASTERS_PUBLIC_IPS},127.0.0.1,${KUBERNETES_HOSTNAMES} \
  -profile=kubernetes \
  $PKI_DIR/kubernetes-csr.json | cfssljson -bare $PKI_DIR/kubernetes
