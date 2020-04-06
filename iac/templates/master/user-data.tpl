#!/usr/bin/env bash

# hostname
hostname "master-${index}"
echo "master-${index}" > /etc/hostname
