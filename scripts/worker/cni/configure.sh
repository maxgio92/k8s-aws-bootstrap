#!/usr/bin/env bash

set -eu

#INDEX=$1

# Download CNI binaries

wget -q --https-only --timestamping \
  "https://github.com/containernetworking/plugins/releases/download/v0.8.2/cni-plugins-linux-amd64-v0.8.2.tgz"
sudo mkdir -p \
  /etc/cni/net.d \
  /opt/cni/bin
sudo tar -xvf \
  cni-plugins-linux-amd64-v0.8.2.tgz -C \
  /opt/cni/bin/

# Configure the CNI loopback network

cat <<EOF | sudo tee /etc/cni/net.d/99-loopback.conf
{
    "cniVersion": "0.3.1",
    "name": "lo",
    "type": "loopback"
}
EOF
