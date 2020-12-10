# Terragrunt will copy the Terraform configurations specified by the source parameter, along with any files in the
# working directory, into a temporary folder, and execute your Terraform commands in that folder.
terraform {
  source = "git@github.com:100Automations/terraform-aws-terragrunt-modules.git//ecs-fargate"
}

locals {
  # Automatically load environment-level variables
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  region_vars = read_terragrunt_config(find_in_parent_folders("region.hcl"))
  account_vars = read_terragrunt_config(find_in_parent_folders("account.hcl"))

  # Extract out common variables for reuse
  env = local.environment_vars.locals.environment
  cidr_block = local.environment_vars.locals.cidr_block
  availability_zones = local.environment_vars.locals.availability_zones

  // Container
  desired_count = local.environment_vars.locals.desired_count
  container_cpu = local.environment_vars.locals.container_cpu
  container_port = local.environment_vars.locals.container_port
  container_memory = local.environment_vars.locals.container_memory
  container_name = "${local.project_name}-${local.env}-container"
  cluster_name = "${local.project_name}-${local.env}-cluster"
  task_name    = "${local.project_name}-${local.env}-task"

  aws_region = local.region_vars.locals.aws_region

  aws_account_id = local.account_vars.locals.aws_account_id
  namespace = local.account_vars.locals.namespace
  project_name = local.account_vars.locals.project_name
  
}
# Include all settings from the root terragrunt.hcl file
include {
  path = find_in_parent_folders()
}

dependencies {
  paths = ["../network", "../rds", "../bastion", "../alb"]
}
dependency "network" {
  config_path = "../network"
  // skip_outputs = true
}
dependency "rds" {
  config_path = "../rds"
  // skip_outputs = true
}
dependency "bastion" {
  config_path = "../bastion"
  // skip_outputs = true
}
dependency "alb" {
  config_path = "../alb"
  // skip_outputs = true
}

# These are the variables we have to pass in to use the module specified in the terragrunt configuration above
inputs = {
  source = "./ecs-fargate"

  // Input from other Modules
  vpc_id                    = dependency.network.outputs.vpc_id
  public_subnet_ids         = dependency.network.outputs.public_subnet_ids
  db_security_group_id      = dependency.rds.outputs.db_security_group_id
  bastion_security_group_id = dependency.bastion.outputs.security_group_id
  aws_ssm_db_hostname_arn   = dependency.rds.outputs.aws_ssm_db_hostname_arn
  aws_ssm_db_password_arn   = dependency.rds.outputs.aws_ssm_db_password_arn
  alb_security_group_id     = dependency.alb.outputs.security_group_id
  alb_target_group_arn      = dependency.alb.outputs.alb_target_group_arn

  // Input from Variables
  account_id  = local.aws_account_id
  region      = local.aws_region
  environment = local.env

  // Container Variables
  desired_count    = local.desired_count
  container_memory = local.container_memory
  container_cpu    = local.container_cpu
  container_port   = local.container_port
  container_name   = local.container_name
  cluster_name     = local.cluster_name
  task_name        = local.task_name
}
