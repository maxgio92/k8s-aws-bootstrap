#!/usr/bin/env bash

set -eu

# Download kubectl binaries
wget -q --https-only --timestamping \
  "https://storage.googleapis.com/kubernetes-release/release/v1.15.3/bin/linux/amd64/kubectl"
chmod +x kubectl
sudo mv kubectl /usr/local/bin/
sudo chown root:root /usr/local/bin/kubectl
