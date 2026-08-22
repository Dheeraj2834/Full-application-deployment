variable "region" {}
variable "project_name" { type = string }
variable "frontend_launch_template_id" { type = string }
variable "web_subnet_1_id" { type = string }
variable "web_subnet_2_id" { type = string }
variable "frontend_target_group_arn" { type = string }
variable "frontend_desired_capacity" { type = number }
variable "frontend_min_size" { type = number }
variable "frontend_max_size" { type = number }
variable "scale_out_target_value" { type = number }