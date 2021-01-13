# Terragrunt will copy the Terraform configurations specified by the source parameter, along with any files in the
# working directory, into a temporary folder, and execute your Terraform commands in that folder.
terraform {
  source = "../../../terraform-modules/bastion-gh"
}

locals {
  # Automatically load environment-level variables
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  account_vars     = read_terragrunt_config(find_in_parent_folders("account.hcl"))

  # Extract out common variables for reuse
  env = local.environment_vars.locals.environment

  aws_region     = local.account_vars.locals.aws_region
  aws_account_id = local.account_vars.locals.aws_account_id
  namespace      = local.account_vars.locals.namespace
  project_name   = local.account_vars.locals.project_name
  cron_key_update_schedule = local.account_vars.locals.cron_key_update_schedule
  github_file              = local.account_vars.locals.github_file

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
  mock_outputs = {
  vpc_id            = "",
  public_subnet_ids = ""
  }
}

# These are the variables we have to pass in to use the module specified in the terragrunt configuration above
inputs = {
  vpc_id            = dependency.network.outputs.vpc_id
  public_subnet_ids = dependency.network.outputs.public_subnet_ids

  account_id = local.aws_account_id
  region     = local.aws_region

  bastion_name = "bastion-${local.project_name}-${local.env}"
  keys_update_frequency = local.cron_key_update_schedule
  github_file           = local.github_file
  key_name              = "cfsj-jumphost"
}
