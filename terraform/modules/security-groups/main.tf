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


# -------------------------
# Standalone rule: allow k8s nodes to reach bastion on 8080 (artifact server)
# -------------------------
# Declared as a standalone aws_security_group_rule rather than an inline
# ingress block on bastion_sg, because:
#
#   bastion_sg has no inline references to k8s_sg,
#   but k8s_sg already references bastion_sg in its SSH and API ingress rules.
#
# Adding an inline reference from bastion_sg -> k8s_sg would create a
# dependency cycle. Using a standalone rule breaks the cycle while still
# achieving the same network policy.

resource "aws_security_group_rule" "bastion_artifact_ingress" {
  type                     = "ingress"
  description              = "Artifact distribution for k8s nodes"
  from_port                = 8080
  to_port                  = 8080
  protocol                 = "tcp"
  security_group_id        = aws_security_group.bastion_sg.id
  source_security_group_id = aws_security_group.k8s_sg.id
}
