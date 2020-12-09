# Terragrunt will copy the Terraform configurations specified by the source parameter, along with any files in the
# working directory, into a temporary folder, and execute your Terraform commands in that folder.
terraform {
  // source = "git::git@github.com:gruntwork-io/terragrunt-infrastructure-modules-example.git//mysql?ref=v0.1.0"
  source = "git@github.com:darpham/aws-terraform-modules.git//ecs-fargate"
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

  aws_region = local.region_vars.locals.aws_region

  aws_account_id = local.account_vars.locals.aws_account_id
  namespace = local.account_vars.locals.namespace
  project_name = local.account_vars.locals.project_name
  bastion_instance_type    = local.account_vars.locals.bastion_instance_type
  cron_key_update_schedule = local.account_vars.locals.cron_key_update_schedule
  ssh_public_key_names     = local.account_vars.locals.ssh_public_key_names
  
}
# Include all settings from the root terragrunt.hcl file
include {
  path = find_in_parent_folders()
}

dependencies {
  paths = ["../network", "../rds", "../bastion"]
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
  alb_security_group_id     = dependency.applicationlb.outputs.security_group_id
  alb_target_group_arn      = dependency.applicationlb.outputs.alb_target_group_arn

  // Input from Variables
  account_id = local.account_id
  region     = local.region
  stage      = local.stage

  // Container Variables
  desired_count    = local.desired_count
  container_memory = local.container_memory
  container_cpu    = local.container_cpu
  container_port   = local.container_port
  container_name   = local.container_name
  cluster_name     = local.cluster_name
  task_name        = local.task_name
  image_tag        = local.image_tag
}
