# ------------------------------------------------------------------------
# Master nodes
# ------------------------------------------------------------------------

# SG

resource "aws_security_group" "cluster_master_nodes" {
  name        = "${local.label}-cluster-master-nodes"
  description = "${local.label} cluster master nodes"
  vpc_id      = module.vpc.vpc_id

  tags = local.tags
}

# SG rules

resource "aws_security_group_rule" "cluster_master_out" {
  description       = "Allow all outbound traffic"
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.cluster_master_nodes.id
}

resource "aws_security_group_rule" "cluster_master_ssh" {
  description       = "Allow SSH from ${var.cluster_ssh_allowed_ip_class}"
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = [var.cluster_ssh_allowed_ip_class]
  security_group_id = aws_security_group.cluster_master_nodes.id
}

resource "aws_security_group_rule" "cluster_apiserver" {
  description       = "Allow traffic to ${local.label} API server"
  type              = "ingress"
  from_port         = var.cluster_apiserver_port
  to_port           = var.cluster_apiserver_port
  protocol          = "tcp"
  cidr_blocks       = [var.cluster_apiserver_allowed_ip_class]
  security_group_id = aws_security_group.cluster_master_nodes.id
}

resource "aws_security_group_rule" "cluster_master_master" {
  description       = "Allow traffic from master nodes"
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  self              = true
  security_group_id = aws_security_group.cluster_master_nodes.id
}

resource "aws_security_group_rule" "cluster_worker_master" {
  description              = "Allow traffic from worker nodes"
  type                     = "ingress"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  source_security_group_id = aws_security_group.cluster_worker_nodes.id
  security_group_id        = aws_security_group.cluster_master_nodes.id
}

resource "aws_security_group_rule" "cluster_pods_master" {
  description       = "Allow traffic from pods"
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = [var.pod_cidr_block]
  security_group_id = aws_security_group.cluster_master_nodes.id
}


# ------------------------------------------------------------------------
# Worker nodes
# ------------------------------------------------------------------------

# SG

resource "aws_security_group" "cluster_worker_nodes" {
  name        = "${local.label}-cluster-worker-nodes"
  description = "${local.label} cluster worker nodes"
  vpc_id      = module.vpc.vpc_id

  tags = local.tags
}

# SG rules

resource "aws_security_group_rule" "cluster_worker_out" {
  description       = "Allow all outbound traffic"
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.cluster_worker_nodes.id
}

resource "aws_security_group_rule" "cluster_worker_ssh" {
  description       = "Allow SSH from ${var.cluster_ssh_allowed_ip_class}"
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = [var.cluster_ssh_allowed_ip_class]
  security_group_id = aws_security_group.cluster_worker_nodes.id
}

resource "aws_security_group_rule" "cluster_worker_worker" {
  description       = "Allow traffic from other worker nodes"
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  self              = true
  security_group_id = aws_security_group.cluster_worker_nodes.id
}

resource "aws_security_group_rule" "cluster_master_worker" {
  description              = "Allow traffic from master nodes"
  type                     = "ingress"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  source_security_group_id = aws_security_group.cluster_master_nodes.id
  security_group_id        = aws_security_group.cluster_worker_nodes.id
}

resource "aws_security_group_rule" "cluster_pods_worker" {
  description       = "Allow traffic from pods"
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = [var.pod_cidr_block]
  security_group_id = aws_security_group.cluster_worker_nodes.id
}

