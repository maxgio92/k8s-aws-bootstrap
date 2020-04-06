#!/usr/bin/env bash

set -eu

# Download CR binaries

wget -q --https-only --timestamping \
  "https://github.com/kubernetes-sigs/cri-tools/releases/download/v1.15.0/crictl-v1.15.0-linux-amd64.tar.gz" \
  "https://github.com/opencontainers/runc/releases/download/v1.0.0-rc8/runc.amd64" \
  "https://github.com/containerd/containerd/releases/download/v1.2.9/containerd-1.2.9.linux-amd64.tar.gz"

tar -xvf crictl-v1.15.0-linux-amd64.tar.gz
mv runc.amd64 runc
mkdir containerd && \
  tar -xvf containerd-1.2.9.linux-amd64.tar.gz -C containerd

chmod +x crictl runc && \
  sudo chown root:root crictl runc && \
  sudo mv crictl runc /usr/local/bin/

chmod +x containerd/bin/* && \
  sudo chown root:root containerd/bin/* && \
  sudo mv containerd/bin/* /bin/

# Configure CR and tools

sudo mkdir -p /etc/containerd/

cat << EOF | sudo tee /etc/containerd/config.toml
[plugins]
  [plugins.cri.containerd]
    snapshotter = "overlayfs"
    [plugins.cri.containerd.default_runtime]
      runtime_type = "io.containerd.runtime.v1.linux"
      runtime_engine = "/usr/local/bin/runc"
      runtime_root = ""
EOF

cat <<EOF | sudo tee /etc/systemd/system/containerd.service
[Unit]
Description=containerd container runtime
Documentation=https://containerd.io
After=network.target

[Service]
ExecStartPre=/sbin/modprobe overlay
ExecStart=/bin/containerd
Restart=always
RestartSec=5
Delegate=yes
KillMode=process
OOMScoreAdjust=-999
LimitNOFILE=1048576
LimitNPROC=infinity
LimitCORE=infinity

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable containerd
