variable "region" { type = string }
variable "project_name" {}
variable "identifier" { type = string }
variable "allocated_storage" { type  = number }
variable "engine" {  type = string }
variable "engine_version" { type = string }
variable "instance_class" { type = string }
variable "multi_az" { type = bool }
variable "db_name" { type = string }
variable "db_username" { type = string }
variable "db_password" {
  type        = string
  sensitive   = true
}
variable "db_subnet_1_id" { type = string }
variable "db_subnet_2_id" { type = string }
variable "rds_sg_id" { type = string }
