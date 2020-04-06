#!/usr/bin/env bash

set -eu

# Download the kube-proxy binaries

wget -q --https-only --timestamping \
  "https://storage.googleapis.com/kubernetes-release/release/v1.15.3/bin/linux/amd64/kube-proxy"
sudo mkdir -p \
  /var/lib/kube-proxy
chmod +x kube-proxy && \
  sudo chown root:root kube-proxy
  sudo mv kube-proxy /usr/local/bin/

# Configure the kube-proxy

sudo mv kube-proxy.kubeconfig /var/lib/kube-proxy/kubeconfig && \
  sudo chown root:root /var/lib/kube-proxy/*

cat <<EOF | sudo tee /var/lib/kube-proxy/kube-proxy-config.yaml
kind: KubeProxyConfiguration
apiVersion: kubeproxy.config.k8s.io/v1alpha1
clientConnection:
  kubeconfig: "/var/lib/kube-proxy/kubeconfig"
mode: "iptables"
clusterCIDR: "10.200.0.0/16"
EOF

cat <<EOF | sudo tee /etc/systemd/system/kube-proxy.service
[Unit]
Description=Kubernetes Kube Proxy
Documentation=https://github.com/kubernetes/kubernetes

[Service]
ExecStart=/usr/local/bin/kube-proxy \\
  --config=/var/lib/kube-proxy/kube-proxy-config.yaml
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable kubelet
