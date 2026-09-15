# -------------------------
# Bastion Security Group
# -------------------------

resource "aws_security_group" "bastion_sg" {
  name        = "bastion-sg"
  description = "Security group for bastion host"
  vpc_id      = var.vpc_id

  ingress {
    description = "SSH from administrator"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${var.my_ip}/32"]
  }

  egress {
    description = "Outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "bastion-sg"
    Role = "bastion"
  }
}


# -------------------------
# Kubernetes Security Group
# -------------------------

resource "aws_security_group" "k8s_sg" {
  name        = "k8s-private-sg"
  description = "Security group for private Kubernetes nodes"
  vpc_id      = var.vpc_id

  # SSH from Bastion only
  ingress {
    description     = "SSH from bastion"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion_sg.id]
  }

  # Kubernetes API Server
  ingress {
    description     = "Kubernetes API server"
    from_port       = 6443
    to_port         = 6443
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion_sg.id]
  }

  # Node-to-node communication
  ingress {
    description = "Kubernetes node-to-node traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    self        = true
  }

  # Outbound traffic
  egress {
    description = "Outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "k8s-private-sg"
    Role = "kubernetes"
  }
}
