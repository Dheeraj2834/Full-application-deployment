variable "region" {}
variable "project_name" { type = string }
variable "backend_launch_template_id" { type = string }
variable "app_subnet_1_id" { type = string }
variable "app_subnet_2_id" { type = string }
variable "backend_target_group_arn" { type = string }
variable "backend_desired_capacity" { type = number }
variable "backend_min_size" { type = number }
variable "backend_max_size" { type = number }
variable "scale_out_target_value" { type = number}