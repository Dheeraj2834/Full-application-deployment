region = "us-east-1"
project_name = "books-three-tier"

frontend_launch_template_id = module.frontend_launchtemplate.frontend_launch_template_id
web_subnet_1_id             = module.vpc.public_subnets[0]
web_subnet_2_id             = module.vpc.public_subnets[1]
frontend_target_group_arn   = module.frontend_alb.alb_target_group_arn

frontend_desired_capacity = 1
frontend_min_size         = 1
frontend_max_size         = 3

scale_out_target_value = 80