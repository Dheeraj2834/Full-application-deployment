output "bastion_instance_id" {
  value = aws_instance.bastionhost.id
}

output "bastion_public_ip" {
  value = aws_instance.bastionhost.public_ip
}

output "bastion_private_ip" {
  value = aws_instance.bastionhost.private_ip
}

output "bastion_instance_name" {
  value = aws_instance.bastionhost.tags
}