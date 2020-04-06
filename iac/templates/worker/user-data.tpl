#!/usr/bin/env bash

hostname "worker-${index}"
echo "worker-${index}" > /etc/hostname

# Worker dependencies
apt-get update && \
  apt-get -y install socat conntrack ipset

# Disable swap for kubelet
swapoff -a
