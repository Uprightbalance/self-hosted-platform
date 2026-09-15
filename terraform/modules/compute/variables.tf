variable "public_subnet_id" {
  description = "Public subnet ID for bastion host"
  type        = string
}

variable "private_subnet_id" {
  description = "Private subnet ID for Kubernetes nodes"
  type        = string
}

variable "bastion_sg_id" {
  description = "Security group ID for bastion host"
  type        = string
}

variable "k8s_sg_id" {
  description = "Security group ID for Kubernetes nodes"
  type        = string
}

variable "public_key" {
  description = "SSH public key"
  type        = string
}
