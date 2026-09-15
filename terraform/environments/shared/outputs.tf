output "vpc_id" {
  description = "VPC ID"
  value       = module.vpc.vpc_id
}

output "public_subnet_id" {
  description = "Public subnet ID"
  value       = module.networking.public_subnet_id
}

output "private_subnet_id" {
  description = "Private subnet ID"
  value       = module.networking.private_subnet_id
}

output "bastion_public_ip" {
  description = "Public IP of bastion host"
  value       = module.compute.bastion_public_ip
}

output "control_plane_private_ip" {
  description = "Private IP of Kubernetes control plane"
  value       = module.compute.control_plane_private_ip
}

output "worker1_private_ip" {
  description = "Private IP of worker node"
  value       = module.compute.worker1_private_ip
}

