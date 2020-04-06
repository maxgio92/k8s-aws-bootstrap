#!/usr/bin/env bash

set -eu

# Download kube-scheduler binaries
wget -q --https-only --timestamping \
  "https://storage.googleapis.com/kubernetes-release/release/v1.15.3/bin/linux/amd64/kube-scheduler"
chmod +x kube-scheduler
sudo mv kube-scheduler /usr/local/bin/
sudo chown root:root /usr/local/bin/kube-scheduler

# Configure kube-scheduler
sudo mv kube-scheduler.kubeconfig /var/lib/kubernetes/
sudo chown root:root /var/lib/kubernetes/kube-scheduler.kubeconfig

sudo mkdir -p /etc/kubernetes/config
cat <<EOF | sudo tee /etc/kubernetes/config/kube-scheduler.yaml
apiVersion: kubescheduler.config.k8s.io/v1alpha1
kind: KubeSchedulerConfiguration
clientConnection:
  kubeconfig: "/var/lib/kubernetes/kube-scheduler.kubeconfig"
leaderElection:
  leaderElect: true
EOF

cat <<EOF | sudo tee /etc/systemd/system/kube-scheduler.service
[Unit]
Description=Kubernetes Scheduler
Documentation=https://github.com/kubernetes/kubernetes

[Service]
ExecStart=/usr/local/bin/kube-scheduler \\
  --config=/etc/kubernetes/config/kube-scheduler.yaml \\
  --v=2
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable kube-scheduler
