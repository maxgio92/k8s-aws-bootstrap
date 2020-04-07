variable "region" {
  type        = string
  description = "AWS Region"
}

variable "vpc_cidr_block" {
  type        = string
  description = "VPC CIDR block"
}

variable "pod_cidr_block" {
  type        = string
  default     = "10.200.0.0/16"
  description = "Pod CIDR block"
}

variable "namespace" {
  type        = string
  description = "Namespace, which could be your organization name, e.g. 'eg' or 'cp'"
}

variable "stage" {
  type        = string
  description = "Stage, e.g. 'prod', 'staging', 'dev' or 'testing'"
}

variable "name" {
  type        = string
  description = "Solution name, e.g. 'app' or 'cluster'"
}

variable "delimiter" {
  type        = string
  default     = "-"
  description = "Delimiter to be used between `name`, `namespace`, `stage`, etc."
}

variable "attributes" {
  type        = list(string)
  default     = []
  description = "Additional attributes (e.g. `1`)"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Additional tags (e.g. `map('BusinessUnit`,`XYZ`)"
}

variable "cluster_master_size" {
  type        = number
  description = "Number of cluster nodes"
}

variable "cluster_worker_size" {
  type        = number
  description = "Number of cluster nodes"
}

variable "cluster_master_disk_size" {
  type        = number
  default     = 8
  description = "EBS volume size of the cluster nodes"
}

variable "cluster_worker_disk_size" {
  type        = number
  default     = 8
  description = "EBS volume size of the cluster nodes"
}

variable "cluster_master_instance_type" {
  type        = string
  default     = "t3.micro"
  description = "EC2 instance type of the cluster nodes"
}

variable "cluster_worker_instance_type" {
  type        = string
  default     = "t3.micro"
  description = "EC2 instance type of the cluster nodes"
}

variable "cluster_ssh_keypair_public_key_path" {
  type        = string
  default     = "~/.ssh/id_rsa.pub"
  description = "The path of the public key to associate to the SSH key pair of the cluster EC2 instances"
}

variable "cluster_ssh_allowed_ip_class" {
  type        = string
  default     = "0.0.0.0/0"
  description = "The IP class allowed to connect via SSH to the cluster nodes"
}

variable "cluster_apiserver_port" {
  type        = number
  default     = 6443
  description = "The port the API server listens on externally"
}

variable "cluster_apiserver_allowed_ip_class" {
  type        = string
  default     = "0.0.0.0/0"
  description = "The IP class allowed to connect to the API server"
}

