#!/usr/bin/env bash

set -eu

PKI_DIR="`pwd`/data/pki"
TERRAFORM_BIN=terraform

WORKERS_PUBLIC_IPS_VARNAME=cluster_worker_nodes_public_ips
WORKERS_PRIVATE_IPS_VARNAME=cluster_worker_nodes_private_ips
WORKERS_COUNT_VARNAME=cluster_worker_size
WORKERS_PUBLIC_IPS=`cd ./iac && $TERRAFORM_BIN output -json -no-color $WORKERS_PUBLIC_IPS_VARNAME`
WORKERS_PRIVATE_IPS=`cd ./iac && $TERRAFORM_BIN output -json -no-color $WORKERS_PRIVATE_IPS_VARNAME`
WORKERS_COUNT=`cd ./iac && $TERRAFORM_BIN output -json -no-color $WORKERS_COUNT_VARNAME`

MASTERS_PUBLIC_IPS_VARNAME=cluster_master_nodes_public_ips
MASTERS_PRIVATE_IPS_VARNAME=cluster_master_nodes_private_ips
MASTERS_COUNT_VARNAME=cluster_master_size
MASTERS_PUBLIC_IPS=`cd ./iac && $TERRAFORM_BIN output -json -no-color $MASTERS_PUBLIC_IPS_VARNAME`
MASTERS_PRIVATE_IPS=`cd ./iac && $TERRAFORM_BIN output -json -no-color $MASTERS_PRIVATE_IPS_VARNAME`
MASTERS_COUNT=`cd ./iac && $TERRAFORM_BIN output -json -no-color $MASTERS_COUNT_VARNAME`

USER=ubuntu
