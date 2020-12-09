# Terragrunt will copy the Terraform configurations specified by the source parameter, along with any files in the
# working directory, into a temporary folder, and execute your Terraform commands in that folder.
terraform {
  source = "git@github.com:darpham/aws-terraform-modules.git//network"
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
  
  namespace = local.account_vars.locals.namespace
  project_name = local.account_vars.locals.project_name
  
}
# Include all settings from the root terragrunt.hcl file
include {
  path = find_in_parent_folders()
}

# These are the variables we have to pass in to use the module specified in the terragrunt configuration above
inputs = {
  region             = local.aws_region
  namespace          = local.namespace
  stage              = local.env
  name               = "${local.project_name}-${local.env}-vpc"
  cidr_block         = local.cidr_block
  availability_zones = local.availability_zones
}
