# Terragrunt will copy the Terraform configurations specified by the source parameter, along with any files in the
# working directory, into a temporary folder, and execute your Terraform commands in that folder.
terraform {
  source = "../../global-resources/../../terraform-modules/service"
}

locals {
  # Automatically load environment-level variables
  project_vars     = read_terragrunt_config("project.hcl")
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  account_vars     = read_terragrunt_config(find_in_parent_folders("account.hcl"))

  # Extract out common variables for reuse
  env = local.environment_vars.locals.environment

  // Container
  desired_count    = local.environment_vars.locals.desired_count
  container_cpu    = local.environment_vars.locals.container_cpu
  container_memory = local.environment_vars.locals.container_memory
  container_name   = "${local.project_name}-${local.env}-container"
  task_name        = "${local.project_name}-${local.env}-task"

  aws_region     = local.account_vars.locals.aws_region
  aws_account_id = local.account_vars.locals.aws_account_id
  namespace      = local.account_vars.locals.namespace
  project_name   = local.account_vars.locals.project_name

}
# Include all settings from the root terragrunt.hcl file
include {
  path = find_in_parent_folders()
}

dependencies {
  paths = ["../../global-resources/network", "../../global-resources/bastion", "../../global-resources/alb", "../../global-resources/ecs"]
}
dependency "network" {
  config_path = "../../global-resources/network"
  // skip_outputs = true
  mock_outputs = {
  vpc_id            = "",
  public_subnet_ids = [],
  }
}
// dependency "rds" {
//   config_path  = "../../global-resources/rds"
//   // skip_outputs = true
//   mock_outputs = {
//   db_security_group_id    = "",
//   aws_ssm_db_hostname_arn = "",
//   aws_ssm_db_password_arn = ""
//   }
// }
dependency "bastion" {
  config_path = "../../global-resources/bastion"
  // skip_outputs = true
  mock_outputs = {
  security_group_id = "",
  }
}
dependency "alb" {
  config_path = "../../global-resources/alb"
  // skip_outputs = true
  mock_outputs = {
  security_group_id    = "",
  alb_target_group_arn = "",
  }
}
dependency "ecs" {
  config_path = "../../global-resources/ecs"
  // skip_outputs = true
  mock_outputs = {
  cluster_name = "",
  cluster_id   = "",
  service_discovery_id = "",
  }
}


# These are the variables we have to pass in to use the module specified in the terragrunt configuration above
inputs = {
  // Input from other Modules
  vpc_id            = dependency.network.outputs.vpc_id
  public_subnet_ids = dependency.network.outputs.public_subnet_ids
  // db_security_group_id      = dependency.rds.outputs.db_security_group_id
  // aws_ssm_db_hostname_arn   = dependency.rds.outputs.aws_ssm_db_hostname_arn
  // aws_ssm_db_password_arn   = dependency.rds.outputs.aws_ssm_db_password_arn
  bastion_security_group_id = dependency.bastion.outputs.security_group_id
  alb_security_group_id     = dependency.alb.outputs.security_group_id
  alb_target_group_arn      = dependency.alb.outputs.alb_target_group_arn
  service_discovery_id      = dependency.ecs.outputs.service_discovery_id
  cluster_name              = dependency.ecs.outputs.cluster_name
  cluster_id                = dependency.ecs.outputs.cluster_id

  // Input from Variables
  account_id  = local.aws_account_id
  region      = local.aws_region
  environment = local.env
  project_name = local.project_name

  // Container Variables
  desired_count    = local.desired_count
  container_memory = local.container_memory
  container_cpu    = local.container_cpu
  container_name   = local.container_name
  task_name        = local.task_name
}
