# frontend server creation

resource "aws_instance" "backend" {
  ami                         = var.ami
  instance_type               = var.instance_type
  key_name                    = var.key_name
  subnet_id                   = var.subnet_id
  vpc_security_group_ids       = [var.security_group_id]
  associate_public_ip_address  = false



  tags = {
    Name = "backend-server"
  }
}