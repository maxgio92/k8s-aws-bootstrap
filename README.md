# Kubernetes AWS Bootstrap

## Step by step guide

### Provision the infrastructure

#### Init

`make init`

#### Provision

`make cluster`

### Generate the PKI infrastructure

`make pki`

### Generate kubeconfigs for clients

`make kubeconfig`

### Configure and bootstrap master components

#### General
`make master`

#### Specific

`make etcd`

`make apiserver`


## Cleanup

`make clean`

## Debug

#### Output infrastruture details

`make output`
