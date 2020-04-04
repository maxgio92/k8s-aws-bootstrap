data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-trusty-14.04-amd64-server-*"]
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

  tags = local.tags
}
