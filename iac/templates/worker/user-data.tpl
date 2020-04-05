#!/usr/bin/env bash

hostname "worker-${index}"
echo "worker-${index}" > /etc/hostname

