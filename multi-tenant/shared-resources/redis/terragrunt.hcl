# Terragrunt will copy the Terraform configurations specified by the source parameter, along with any files in the
# working directory, into a temporary folder, and execute your Terraform commands in that folder.
terraform {
  source = "../../../terraform-modules//redis"
}

locals {
  # Automatically load environment-level variables
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  account_vars     = read_terragrunt_config(find_in_parent_folders("account.hcl"))

  # Extract out common variables for reuse
  aws_region    = local.account_vars.locals.aws_region
  namespace     = local.account_vars.locals.namespace
  resource_name = local.account_vars.locals.resource_name

  env  = local.environment_vars.locals.environment
  tags = local.environment_vars.locals.tags
}
# Include all settings from the root terragrunt.hcl file
include {
  path = find_in_parent_folders()
}

dependencies {
  paths = ["../network", "../alb", "../ecs", "../private-dns"]
}
dependency "network" {
  config_path = "../network"
  // skip_outputs = true
  mock_outputs = {
    vpc_id            = "",
    public_subnet_ids = [],
  }
}
dependency "alb" {
  config_path = "../alb"
  // skip_outputs = true
  mock_outputs = {
    security_group_id      = "",
    alb_target_group_arn   = "",
    alb_https_listener_arn = "",
  }
}
dependency "ecs" {
  config_path = "../ecs"
  // skip_outputs = true
  mock_outputs = {
    cluster_name      = "",
    cluster_id        = "",
    asg_capacity_prov = "",
  }
}
dependency "private-dns" {
  config_path = "../private-dns"
  // skip_outputs = true
  mock_outputs = {
    private_dns_id = "",
  }
}

# These are the variables we have to pass in to use the module specified in the terragrunt configuration above
inputs = {
  // Input from other Modules
  vpc_id            = dependency.network.outputs.vpc_id
  public_subnet_ids = dependency.network.outputs.public_subnet_ids
  cluster_name      = dependency.ecs.outputs.cluster_name
  cluster_id        = dependency.ecs.outputs.cluster_id
  private_dns_id    = dependency.private-dns.outputs.private_dns_id

  // Input from Variables
  region           = local.aws_region
  environment      = local.env
  resource_name    = local.resource_name
  tags             = local.tags
  container_memory = 0
  container_cpu    = 0
}
