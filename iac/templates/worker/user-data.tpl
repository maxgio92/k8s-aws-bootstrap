#!/usr/bin/env bash

HOSTNAME=`curl -s http://169.254.169.254/latest/meta-data/hostname/`
hostnamectl set-hostname $HOSTNAME
