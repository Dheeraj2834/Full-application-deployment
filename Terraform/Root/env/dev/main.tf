# VPC, Subnets, IGW, NAT, Route tables, security groups creation

module "vpc" {
  source = "../../modules/inftastructure"
  vpc_region = "us-east-1"
vpc_name   = "Dheeraj-VPC"
vpc_cidr   = "10.0.0.0/16"

az_1a = "us-east-1a"
az_1b = "us-east-1b"

public_subnet_1_cidr = "10.0.0.0/24"
public_subnet_2_cidr = "10.0.1.0/24"

private_subnet_1_cidr = "10.0.2.0/24"
private_subnet_2_cidr = "10.0.3.0/24"
private_subnet_3_cidr = "10.0.4.0/24"
private_subnet_4_cidr = "10.0.5.0/24"
private_subnet_5_cidr = "10.0.6.0/24"
private_subnet_6_cidr = "10.0.7.0/24"

vpc_id            = module.vpc.vpc_id
allowed_ssh_cidr = ["0.0.0.0/0"]
}

# bastion host server creation

module "bastionhost" {
  source = "../../modules/bastion-host"

  region = "us-east-1"
  ami = "ami-004f790b835b26145"
  instance_type = "t3.micro"
  key_name = "Dhe"
  subnet_id = module.vpc.public_subnets[0]
  security_group_id = module.vpc.bastion_sg_id
}

# Frontend server creation

module "frontend" {
  source = "../../modules/frontend/Ec2"

  region = "us-east-1"
  ami = "ami-004f790b835b26145"
  instance_type = "t3.micro"
  key_name = "Dhe"
  subnet_id = module.vpc.private_web_subnets[0]
  security_group_id = module.vpc.frontend_server_sg_id
}

# backend server creation

module "backend" {
  source = "../../modules/backend/Ec2"

  region = "us-east-1"
  ami = "ami-004f790b835b26145"
  instance_type = "t3.micro"
  key_name = "Dhe"
  subnet_id = module.vpc.private_app_subnets[0]
  security_group_id = module.vpc.backend_server_sg_id
}

# frontend load balancer

module "frontend_alb" {
  source = "../../modules/frontend/loadbalancer-frontend"

  region = "us-east-1"
  vpc_id = module.vpc.vpc_id
  subnets = module.vpc.public_subnets
  security_group_id = module.vpc.alb_frontend_sg_id
  alb_name = "frontend-alb"
  target_group_name = "frontend-tg"
}

# backend load balancer

module "backend_alb" {
  source = "../../modules/backend/loadbalancer-backend"

  region = "us-east-1"
  vpc_id = module.vpc.vpc_id
  subnets = module.vpc.public_subnets
  security_group_id = module.vpc.alb_backend_sg_id
  alb_name = "backend-alb"
  target_group_name = "backend-tg"
}

# Database creation

module "database" {
  source = "../../modules/database"
  region   = "us-east-1"
  project_name = "Springboot"
  identifier   = "Dheeraj"
  allocated_storage = 20
  engine            = "mysql"
  engine_version    = "8.0"
  instance_class    = "db.t3.micro"
  multi_az          = false
  db_name           = "Springboot"
  db_username       = "admin"
  db_password       = "Cloud123"
  db_subnet_1_id    = module.vpc.private_db_subnets[0]
  db_subnet_2_id    = module.vpc.private_db_subnets[1]
  rds_sg_id         = module.vpc.database_sg_id
}

# frontend AMi and Launch Template

module "frontend_launchtemplate" {
  source = "../../modules/frontend/launch-template"

  region   = "us-east-1"
  project_name   = "three-tier"
  instance_type  = "t3.micro"
  frontend_sg_id = module.vpc.frontend_server_sg_id
  key_name       = "Dhe"
  instanceid = module.frontend.frontend_instance_id
}

# Frontend ASG

module "asg_frontend" {
  source = "../../modules/frontend/asg"

  region = "us-east-1"
  project_name = "frontend-three-tier"

  frontend_launch_template_id = module.frontend_launchtemplate.frontend_launch_template_id
  web_subnet_1_id             = module.vpc.public_subnets[0]
  web_subnet_2_id             = module.vpc.public_subnets[1]
  frontend_target_group_arn   = module.frontend_alb.alb_target_group_arn

  frontend_desired_capacity = 1
  frontend_min_size         = 1
  frontend_max_size         = 3

  scale_out_target_value = 80
}

# backend AMi and Launch Template

module "backend_launchtemplate" {
  source = "../../modules/backend/launch-template"

  region   = "us-east-1"
  project_name   = "three-tier"
  instance_type  = "t3.micro"
  backend_sg_id  = module.vpc.backend_server_sg_id
  key_name       = "Dhe"
  instanceid = module.backend.backend_instance_id
}

# Backend ASG

module "asg_backend" {
  source = "../../modules/backend/asg"

  region = "us-east-1"
 project_name = "three-tier"

  backend_launch_template_id = module.backend_launchtemplate.backend_launch_template_id
  app_subnet_1_id            = module.vpc.private_app_subnets[0]
  app_subnet_2_id            = module.vpc.private_app_subnets[1]
  backend_target_group_arn   = module.backend_alb.alb_target_group_arn
  backend_desired_capacity = 1
  backend_min_size         = 1
  backend_max_size         = 3
  scale_out_target_value = 80
}
