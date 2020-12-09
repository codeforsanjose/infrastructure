# Terragrunt will copy the Terraform configurations specified by the source parameter, along with any files in the
# working directory, into a temporary folder, and execute your Terraform commands in that folder.
terraform {
  // source = "git::git@github.com:gruntwork-io/terragrunt-infrastructure-modules-example.git//mysql?ref=v0.1.0"
  source = "git@github.com:darpham/aws-terraform-modules.git//applicationlb"
}

locals {
  # Automatically load environment-level variables
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  region_vars      = read_terragrunt_config(find_in_parent_folders("region.hcl"))
  account_vars     = read_terragrunt_config(find_in_parent_folders("account.hcl"))

  # Extract out common variables for reuse
  env                = local.environment_vars.locals.environment
  cidr_block         = local.environment_vars.locals.cidr_block
  availability_zones = local.environment_vars.locals.availability_zones
  container_port     = local.environment_vars.locals.container_port
  tags               = local.environment_vars.locals.tags

  aws_region = local.region_vars.locals.aws_region

  aws_account_id           = local.account_vars.locals.aws_account_id
  namespace                = local.account_vars.locals.namespace
  project_name             = local.account_vars.locals.project_name
  bastion_instance_type    = local.account_vars.locals.bastion_instance_type
  cron_key_update_schedule = local.account_vars.locals.cron_key_update_schedule
  ssh_public_key_names     = local.account_vars.locals.ssh_public_key_names

  // Container extrapolation
  task_name = "${local.project_name}-task"
  
}
# Include all settings from the root terragrunt.hcl file
include {
  path = find_in_parent_folders()
}

dependencies {
  paths = ["../network", "../acm"]
}
dependency "network" {
  config_path = "../network"
  // skip_outputs = true
}
dependency "acm" {
  config_path = "../acm"
  // skip_outputs = true
}

# These are the variables we have to pass in to use the module specified in the terragrunt configuration above
inputs = {
  // Input from other Modules
  vpc_id              = dependency.network.outputs.vpc_id
  public_subnet_ids   = dependency.network.outputs.public_subnet_ids
  acm_certificate_arn = dependency.acm.outputs.acm_certificate_arn

  // Input from Variables
  account_id   = local.aws_account_id
  region       = local.aws_region
  environment  = local.env
  project_name = local.project_name

  // Container Variables
  container_port = local.container_port
  task_name      = local.task_name
  tags           = local.tags
}