# Set account-wide variables. These are automatically pulled in to configure the remote state bucket in the root
# terragrunt.hcl configuration.
locals {
  account_name   = "dpham"
  aws_account_id = "253016134262"
  aws_region     = "us-west-1"
  namespace    = "cfsj"
  project_name = "multi-tenant"

  // datetime is going to be added to tags for terraform creation date
  datetime = { date_processed = formatdate("YYYYMMDDhhmmss", timestamp()) }

  
  cron_key_update_schedule = "5,0,*,* * * * *"
  github_file              = {
    github_repo_owner = "codeforsanjose",
    github_repo_name  = "Infrastructure",
    github_branch     = "main",
    github_filepath   = "bastion_github_users",
  }
}