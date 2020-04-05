data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_key_pair" "cluster" {
  key_name   = local.label
  public_key = file(var.cluster_ssh_keypair_public_key_path)
}

resource "aws_instance" "cluster_master_node" {
  count = var.cluster_master_size

  ami           = data.aws_ami.ubuntu.id
  key_name      = aws_key_pair.cluster.key_name
  instance_type = var.cluster_master_instance_type
  root_block_device {
    volume_size = var.cluster_master_disk_size
  }
  subnet_id              = module.subnets.public_subnet_ids[0]
  vpc_security_group_ids = [aws_security_group.cluster_master_nodes.id]
  user_data              = templatefile("${path.module}/templates/master/user-data.tpl", { index = count.index })

  tags = local.tags
}

resource "aws_instance" "cluster_worker_node" {
  count = var.cluster_worker_size

  ami           = data.aws_ami.ubuntu.id
  key_name      = aws_key_pair.cluster.key_name
  instance_type = var.cluster_worker_instance_type
  root_block_device {
    volume_size = var.cluster_worker_disk_size
  }
  subnet_id              = module.subnets.public_subnet_ids[0]
  vpc_security_group_ids = [aws_security_group.cluster_worker_nodes.id]
  user_data              = templatefile("${path.module}/templates/worker/user-data.tpl", { index = count.index })

  tags = local.tags
}

resource "aws_security_group" "cluster_master_nodes" {
  name        = "${local.label}-cluster-master-nodes"
  description = "Allow basic traffic to ${local.label} cluster master nodes"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "Allow SSH from Internet"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.cluster_ssh_allowed_ip_class]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = local.tags
}

resource "aws_security_group" "cluster_worker_nodes" {
  name        = "${local.label}-cluster-worker-nodes"
  description = "Allow basic traffic to ${local.label} cluster worker nodes"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "Allow SSH from Internet"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.cluster_ssh_allowed_ip_class]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = local.tags
}
