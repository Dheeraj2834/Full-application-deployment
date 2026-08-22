output "frontend_public_ip" {
  value = aws_instance.frontend.private_ip
}

output "frontend_instance_id" {
  value = aws_instance.frontend.id
}