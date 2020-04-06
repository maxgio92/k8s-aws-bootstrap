# Kubernetes AWS Bootstrap

## Step by step guide

### Provision the infrastructure

#### Init

`make init`

#### Provision

`make cluster`

### Generate the PKI infrastructure

`make pki`

### Generate kubeconfigs

`make kubeconfig`

### Configure and bootstrap master components

#### General
`make master`

#### Specific

`make etcd`

`make apiserver`

`make controllermanager`

`make scheduler`

`make kubectl`

`make kubeletauth`

### Configure and bootstrap worker components

#### General
`make worker`

#### Specific

`make workerdeps`

`make cni`


## Cleanup

`make clean`

## Debug

#### Output infrastruture details

`make output`
