terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = var.aws_region
  profile = var.aws_profile
}

module "vpc" {
  source = "./modules/vpc"

  project_name = var.project_name
}

module "launch_template" {
  source = "./modules/launch-template"
  project_name = var.project_name
  vpc_id = module.vpc.vpc_id
}

module "alb" {
  source = "./modules/alb"
  project_name = var.project_name
  vpc_id = module.vpc.vpc_id
  public_subnet_ids = module.vpc.public_subnet_ids
  alb_security_groups_id = module.launch_template.alb_security_groups_id
}

module "asg" {
  source = "./modules/asg"
  project_name = var.project_name
  private_subnet_ids = module.vpc.private_subnet_ids
  launch_template_id = module.launch_template.launch_template_id
  launch_template_version = module.launch_template.launch_template_version
  lb_target_group_arn = module.alb.lb_target_group_arn
}

module "monitoring" {
  source = "./modules/monitoring"
  project_name = var.project_name
  autoscaling_group_name = module.asg.autoscaling_group_name
  autoscaling_policy_dwn_arn = module.asg.autoscaling_policy_dwn_arn
  account-id = var.account-id
  autoscaling_policy_up_arn = module.asg.autoscaling_policy_up_arn
  notification_email = var.notification_email
}