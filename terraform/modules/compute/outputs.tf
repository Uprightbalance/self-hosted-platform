output "bastion_public_ip" {
  value = aws_instance.bastion.public_ip
}

output "control_plane_private_ip" {
  value = aws_instance.control_plane.private_ip
}

output "worker1_private_ip" {
  value = aws_instance.worker1.private_ip
}

