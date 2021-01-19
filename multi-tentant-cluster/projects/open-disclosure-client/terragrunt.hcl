# Terragrunt will copy the Terraform configurations specified by the source parameter, along with any files in the
# working directory, into a temporary folder, and execute your Terraform commands in that folder.
terraform {
  source = "../../../terraform-modules/service-client"
}

locals {
  # Automatically load environment-level variables
  project_vars     = read_terragrunt_config("project.hcl")
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  account_vars     = read_terragrunt_config(find_in_parent_folders("account.hcl"))

  # Extract out common variables for reuse
  env = local.environment_vars.locals.environment

  // Container
  container_image  = local.project_vars.locals.container_image
  desired_count    = local.project_vars.locals.desired_count
  container_port   = local.project_vars.locals.container_port
  container_cpu    = local.project_vars.locals.container_cpu
  container_memory = local.project_vars.locals.container_memory
  container_env_vars = local.project_vars.locals.container_env_vars

  project_name = local.project_vars.locals.project_name
  host_name    = local.project_vars.locals.host_name

  aws_region     = local.account_vars.locals.aws_region
  aws_account_id = local.account_vars.locals.aws_account_id
  namespace      = local.account_vars.locals.namespace

}
# Include all settings from the root terragrunt.hcl file
include {
  path = find_in_parent_folders()
}

dependencies {
  paths = ["../../global-resources/network", "../../global-resources/alb", "../../global-resources/ecs"]
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
dependency "alb" {
  config_path = "../../global-resources/alb"
  // skip_outputs = true
  mock_outputs = {
  security_group_id      = "",
  alb_target_group_arn   = "",
  alb_https_listener_arn = "",
  }
}
dependency "ecs" {
  config_path = "../../global-resources/ecs"
  // skip_outputs = true
  mock_outputs = {
  cluster_name      = "",
  cluster_id        = "",
  asg_capacity_prov = "",
  }
}


# These are the variables we have to pass in to use the module specified in the terragrunt configuration above
inputs = {
  // Input from other Modules
  vpc_id                 = dependency.network.outputs.vpc_id
  public_subnet_ids      = dependency.network.outputs.public_subnet_ids
  alb_target_group_arn   = dependency.alb.outputs.alb_target_group_arn
  alb_https_listener_arn = dependency.alb.outputs.alb_https_listener_arn
  cluster_name           = dependency.ecs.outputs.cluster_name
  cluster_id             = dependency.ecs.outputs.cluster_id
  asg_capacity_prov      = dependency.ecs.outputs.asg_capacity_prov

  // Input from Variables
  account_id   = local.aws_account_id
  region       = local.aws_region
  environment  = local.env
  project_name = local.project_name
  host_name    = local.host_name

  // Container Variables
  container_image  = local.container_image
  desired_count    = local.desired_count
  container_port   = local.container_port
  container_memory = local.container_memory
  container_cpu    = local.container_cpu
  container_env_vars = local.container_env_vars
}
