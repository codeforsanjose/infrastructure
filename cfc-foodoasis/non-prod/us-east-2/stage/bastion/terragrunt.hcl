# Terragrunt will copy the Terraform configurations specified by the source parameter, along with any files in the
# working directory, into a temporary folder, and execute your Terraform commands in that folder.
terraform {
  source = "git@github.com:100Automations/terraform-aws-terragrunt-modules.git//bastion-gh"
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
  // bastion_instance_type    = local.account_vars.locals.bastion_instance_type
  cron_key_update_schedule = local.account_vars.locals.cron_key_update_schedule
  github_usernames     = local.account_vars.locals.github_usernames
  
}
# Include all settings from the root terragrunt.hcl file
include {
  path = find_in_parent_folders()
}

dependencies {
  paths = ["../network"]
}
dependency "network" {
  config_path = "../network"
  // skip_outputs = true
}

# These are the variables we have to pass in to use the module specified in the terragrunt configuration above
inputs = {
  vpc_id            = dependency.network.outputs.vpc_id
  public_subnet_ids = dependency.network.outputs.public_subnet_ids

  account_id = local.aws_account_id
  region     = local.aws_region

  bastion_name             = "bastion-${local.project_name}-${local.env}"
  ssh_user = "ec2-user"
  // bastion_instance_type    = local.bastion_instance_type
  cron_key_update_schedule = local.cron_key_update_schedule
  github_usernames     = local.github_usernames
}
