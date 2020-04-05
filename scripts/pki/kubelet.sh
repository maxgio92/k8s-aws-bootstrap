#!/usr/bin/env bash

set -eu

source "`pwd`/scripts/__helpers.sh"

n=0
while [ "$n" -lt "$WORKERS_COUNT" ]; do
  WORKER_NAME="worker-${n}"
  WORKER_PUBLIC_IP=`echo $WORKERS_PUBLIC_IPS | jq ".[${n}]" | tr -d '"'`
  WORKER_PRIVATE_IP=`echo $WORKERS_PRIVATE_IPS | jq ".[${n}]" | tr -d '"'`

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
