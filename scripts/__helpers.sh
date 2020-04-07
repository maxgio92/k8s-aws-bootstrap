#!/usr/bin/env bash

set -eu

PKI_DIR="`pwd`/data/pki"
KUBECONFIG_DIR="`pwd`/data/kubeconfig"
TERRAFORM_BIN=terraform
USER=ubuntu
APISERVER_PORT=6443
KUBECONFIG_CLUSTER_NAME=k8s-aws-bootstrap

WORKERS_PUBLIC_IPS_VARNAME=cluster_worker_nodes_public_ips
WORKERS_PRIVATE_IPS_VARNAME=cluster_worker_nodes_private_ips
WORKERS_PRIVATE_DNS_VARNAME=cluster_worker_nodes_private_dns
WORKERS_COUNT_VARNAME=cluster_worker_size
WORKERS_PUBLIC_IPS=`cd ./iac && $TERRAFORM_BIN output -json -no-color $WORKERS_PUBLIC_IPS_VARNAME`
WORKERS_PRIVATE_IPS=`cd ./iac && $TERRAFORM_BIN output -json -no-color $WORKERS_PRIVATE_IPS_VARNAME`
WORKERS_PRIVATE_DNS=`cd ./iac && $TERRAFORM_BIN output -json -no-color $WORKERS_PRIVATE_DNS_VARNAME`
WORKERS_COUNT=`cd ./iac && $TERRAFORM_BIN output -json -no-color $WORKERS_COUNT_VARNAME`

MASTERS_PUBLIC_IPS_VARNAME=cluster_master_nodes_public_ips
MASTERS_PRIVATE_IPS_VARNAME=cluster_master_nodes_private_ips
MASTERS_COUNT_VARNAME=cluster_master_size
MASTERS_PUBLIC_IPS=`cd ./iac && $TERRAFORM_BIN output -json -no-color $MASTERS_PUBLIC_IPS_VARNAME`
MASTER_PUBLIC_IP=`echo $MASTERS_PUBLIC_IPS | jq ".[0]" | tr -d '"'`
MASTERS_PRIVATE_IPS=`cd ./iac && $TERRAFORM_BIN output -json -no-color $MASTERS_PRIVATE_IPS_VARNAME`
MASTERS_COUNT=`cd ./iac && $TERRAFORM_BIN output -json -no-color $MASTERS_COUNT_VARNAME`
