# Terragrunt will copy the Terraform configurations specified by the source parameter, along with any files in the
# working directory, into a temporary folder, and execute your Terraform commands in that folder.
terraform {
  source = "git@github.com:100Automations/terraform-aws-terragrunt-modules.git//rds"
}

locals {
  # Automatically load environment-level variables
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  region_vars      = read_terragrunt_config(find_in_parent_folders("region.hcl"))
  account_vars     = read_terragrunt_config(find_in_parent_folders("account.hcl"))

  # Extract out common variables for reuse
  env                   = local.environment_vars.locals.environment
  cidr_block            = local.environment_vars.locals.cidr_block
  availability_zones    = local.environment_vars.locals.availability_zones
  db_snapshot_migration = local.environment_vars.locals.db_snapshot_migration

  aws_region = local.region_vars.locals.aws_region

  namespace    = local.account_vars.locals.namespace
  project_name = local.account_vars.locals.project_name
  datetime     = local.account_vars.locals.datetime

}
# Include all settings from the root terragrunt.hcl file
include {
  path = find_in_parent_folders()
}

dependencies {
  paths = ["../network", "../bastion"]
}
dependency "network" {
  config_path = "../network"
  // skip_outputs = true
  mock_outputs = {
  vpc_id = "",
  private_subnet_ids = [],
  private_subnet_cidrs = []
  }
}
dependency "bastion" {
  config_path = "../bastion"
  // skip_outputs = true
  mock_outputs = {
  security_group_id = ""
  }
}

# These are the variables we have to pass in to use the module specified in the terragrunt configuration above
inputs = {
  project_name = local.project_name
  stage        = local.env
  region       = local.aws_region
  datetime     = local.datetime

  db_username = get_env("DB_USERNAME")
  db_name     = get_env("DB_NAME")
  db_password = get_env("DB_PASSWORD")
  db_port     = get_env("DB_PORT")

  // Use either instance to pull latest snaphsot for DB
  // !! Does not currently work if AWS Provider is in a different region
  // db_instance_id_migration     = local.db_instance_id_migration
  // db_instance_region_migration = local.db_instance_region_migration

  // OR specify snapshot directly
  db_snapshot_migration = local.db_snapshot_migration

  // Module Network variables
  vpc_id                    = dependency.network.outputs.vpc_id
  private_subnet_ids        = dependency.network.outputs.private_subnet_ids
  private_subnet_cidrs      = dependency.network.outputs.private_subnet_cidrs
  bastion_security_group_id = dependency.bastion.outputs.security_group_id
}
