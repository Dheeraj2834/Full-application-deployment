provider "aws" {
  region = var.region
}

resource "aws_instance" "server" {
  for_each = var.instances

  instance_type = each.value
  ami           = "ami-0332d564d76dbd8d6"
}

variable "region" {
  default = "us-east-1"
}

variable "instances" {
  default = {
    web = "t3.small"
    api = "t3.micro"
  }
}