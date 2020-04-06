#!/usr/bin/env bash

set -eu

sudo apt-get update && \
  sudo apt-get -y install \
  socat \
  conntrack \
  ipset
