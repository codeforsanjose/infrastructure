# Terragrunt will copy the Terraform configurations specified by the source parameter, along with any files in the
# working directory, into a temporary folder, and execute your Terraform commands in that folder.
terraform {
  source = "git@github.com:darpham/aws-terraform-modules.git//r53"
}

locals {
  # Automatically load environment-level variables
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  region_vars      = read_terragrunt_config(find_in_parent_folders("region.hcl"))
  account_vars     = read_terragrunt_config(find_in_parent_folders("account.hcl"))

  # Extract out common variables for reuse
  domain_name = local.environment_vars.locals.domain_name
  host_name   = local.environment_vars.locals.host_name
}
# Include all settings from the root terragrunt.hcl file
include {
  path = find_in_parent_folders()
}

dependencies {
  paths = ["../acm", "../alb"]
}
dependency "acm" {
  config_path = "../acm"
  // skip_outputs = true
}
dependency "alb" {
  config_path = "../alb"
  // skip_outputs = true
}

# These are the variables we have to pass in to use the module specified in the terragrunt configuration above
inputs = {
  // Input from other Modules
  alb_external_dns     = dependency.alb.outputs.lb_dns_name

  // Input from Variables
  domain_name = local.domain_name
  host_name   = local.host_name
}
