// Currently Not Used
// Purpose of this module was to create DNS records to Name Cheap .org
// NameCheap is cheap and wants $$ to enable API
// We’re sorry, you have not met the criteria to qualify for API access.
// To qualify, you must have: Account balance of $50+, 20+ domains in your account, or purchases totaling $50+ within the last 2 years.

// # Terragrunt will copy the Terraform configurations specified by the source parameter, along with any files in the
// # working directory, into a temporary folder, and execute your Terraform commands in that folder.
// terraform {
//   source = "../../../terraform-modules/namecheap"
// }

// locals {
//   # Automatically load environment-level variables
//   environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
//   account_vars     = read_terragrunt_config(find_in_parent_folders("account.hcl"))

//   # Extract out common variables for reuse
//   domain_name = local.environment_vars.locals.domain_name
//   host_names  = local.environment_vars.locals.host_names
// }
// # Include all settings from the root terragrunt.hcl file
// include {
//   path = find_in_parent_folders()
// }

// dependencies {
//   paths = ["../alb"]
// }
// dependency "alb" {
//   config_path = "../alb"
//   skip_outputs = true
//   mock_outputs = {
//   lb_dns_name = ""
//   }
// }

// # These are the variables we have to pass in to use the module specified in the terragrunt configuration above
// inputs = {
//   // Input from other Modules
//   alb_external_dns = dependency.alb.outputs.lb_dns_name

//   // Input from Variables
//   domain_name = local.domain_name
//   host_names  = local.host_names
// }
