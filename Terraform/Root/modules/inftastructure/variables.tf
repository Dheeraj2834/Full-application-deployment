variable "vpc_region" {
  type = string
}

variable "vpc_name" {
  type = string
}

variable "vpc_cidr" {
  type = string
}

variable "az_1a" {
  type = string
}

variable "az_1b" {
  type = string
}

variable "public_subnet_1_cidr" {
  type = string
}

variable "public_subnet_2_cidr" {
  type = string
}

variable "private_subnet_1_cidr" {
  type = string
}

variable "private_subnet_2_cidr" {
  type = string
}

variable "private_subnet_3_cidr" {
  type = string
}

variable "private_subnet_4_cidr" {
  type = string
}

variable "private_subnet_5_cidr" {
  type = string
}

variable "private_subnet_6_cidr" {
  type = string
}

variable "vpc_id" {
  description = "VPC ID where security groups will be created"
  type        = string
}

variable "allowed_ssh_cidr" {
  description = "CIDR blocks allowed for SSH access"
  type        = list(string)
}