region = "eu-west-1"

availability_zones = ["eu-west-1a"]

vpc_cidr_block = "172.16.0.0/16"

namespace = "sample"

stage = "k8s" # environments isolated at namespace level

name = "k8s-bootstrap"

cluster_master_size = 3

cluster_worker_size = 3
