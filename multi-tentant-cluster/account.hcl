# Set account-wide variables. These are automatically pulled in to configure the remote state bucket in the root
# terragrunt.hcl configuration.
locals {
  account_name   = "dpham"
  aws_account_id = "253016134262"
  aws_region     = "us-west-1"
  namespace      = "cfsj"
  resource_name  = "multi-tenant"
  
}