output "bastion_sg_id" {
  value = aws_security_group.bastion_sg.id
}

output "k8s_sg_id" {
  value = aws_security_group.k8s_sg.id
}
