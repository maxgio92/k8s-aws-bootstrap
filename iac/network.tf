module "vpc" {
  source                                          = "git::https://github.com/cloudposse/terraform-aws-vpc.git?ref=tags/0.9.0"
  enable_default_security_group_with_custom_rules = false
  namespace                                       = var.namespace
  stage                                           = var.stage
  name                                            = var.name
  attributes                                      = var.attributes
  cidr_block                                      = var.vpc_cidr_block
  tags                                            = local.tags
}

module "subnets" {
  source               = "git::https://github.com/cloudposse/terraform-aws-dynamic-subnets.git?ref=tags/0.18.1"
  availability_zones   = ["eu-west-1a"]
  namespace            = var.namespace
  stage                = var.stage
  name                 = var.name
  attributes           = var.attributes
  vpc_id               = module.vpc.vpc_id
  igw_id               = module.vpc.igw_id
  cidr_block           = module.vpc.vpc_cidr_block
  nat_gateway_enabled  = false
  nat_instance_enabled = false
  tags                 = local.tags
}

resource "aws_route" "pods_to_worker_nodes" {
  count                  = length(aws_instance.cluster_worker_node)
  route_table_id         = module.subnets.public_route_table_ids[0]
  destination_cidr_block = cidrsubnet(var.pod_cidr_block, 8, count.index)
  instance_id            = aws_instance.cluster_worker_node[count.index].id
}
