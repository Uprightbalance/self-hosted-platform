# -------------------------
# SSH Key Pair
# -------------------------

resource "aws_key_pair" "devops_key" {
  key_name   = "devops-key"
  public_key = var.public_key
}


# -------------------------
# Ubuntu AMI
# -------------------------

data "aws_ami" "ubuntu" {
  most_recent = true

  owners = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
}


# -------------------------
# Bastion Host
# -------------------------

resource "aws_instance" "bastion" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = "t3.micro"
  subnet_id                   = var.public_subnet_id
  vpc_security_group_ids      = [var.bastion_sg_id]
  associate_public_ip_address = true
  key_name                    = aws_key_pair.devops_key.key_name

  root_block_device {
    volume_size = 10
    volume_type = "gp3"
    encrypted   = true
  }

  tags = {
    Name = "bastion"
    Role = "bastion"
  }
}


# -------------------------
# Kubernetes Control Plane
# -------------------------

resource "aws_instance" "control_plane" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t3.small"
  subnet_id              = var.private_subnet_id
  vpc_security_group_ids = [var.k8s_sg_id]
  key_name               = aws_key_pair.devops_key.key_name

  root_block_device {
    volume_size = 30
    volume_type = "gp3"
    encrypted   = true
  }

  tags = {
    Name = "control-plane"
    Role = "k8s-control-plane"
  }
}


# -------------------------
# Kubernetes Worker 1
# -------------------------

resource "aws_instance" "worker1" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t3.small"
  subnet_id              = var.private_subnet_id
  vpc_security_group_ids = [var.k8s_sg_id]
  key_name               = aws_key_pair.devops_key.key_name

  root_block_device {
    volume_size = 30
    volume_type = "gp3"
    encrypted   = true
  }

  tags = {
    Name        = "worker1"
    Role        = "k8s-worker"
    Environment = "dev"
  }
}


# -------------------------
# Kubernetes Worker 2
# -------------------------

resource "aws_instance" "worker2" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t3.small"
  subnet_id              = var.private_subnet_id
  vpc_security_group_ids = [var.k8s_sg_id]
  key_name               = aws_key_pair.devops_key.key_name

  root_block_device {
    volume_size = 30
    volume_type = "gp3"
    encrypted   = true
  }

  tags = {
    Name        = "worker2"
    Role        = "k8s-worker"
    Environment = "dev"
  }
}
