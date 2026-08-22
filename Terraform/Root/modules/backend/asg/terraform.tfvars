# region = "us-east-1"
# project_name = "books-three-tier"

# backend_launch_template_id = module.backend_launchtemplate.backend_launch_template_id
# app_subnet_1_id            = module.vpc.private_app_subnets[0]
# app_subnet_2_id            = module.vpc.private_app_subnets[1]
# backend_target_group_arn   = module.backend_alb.alb_target_group_arn
# backend_desired_capacity = 1
# backend_min_size         = 1
# backend_max_size         = 3
# scale_out_target_value = 80