# Set account-wide variables. These are automatically pulled in to configure the remote state bucket in the root
# terragrunt.hcl configuration.
locals {
  account_name   = "DarrentPham"
  aws_account_id = "470363915259"
  aws_profile    = "default"
  namespace      = "cfc"
  project_name   = "food-oasis"

  // datetime is going to be added to tags for terraform creation date
  datetime     = { date_processed = formatdate("YYYYMMDDhhmmss", timestamp()) }

  
  // bastion_instance_type    = "t2.micro"
  cron_key_update_schedule = "5,0,*,* * * * *"
  github_file     = {
    github_repo_owner           = "codeforsanjose",
    github_repo_name            = "Infrastructure",
    github_branch               = "main",
    github_filepath             = "cfc-foodoasis/non-prod/us-east-2/stage/bastion/bastion_github_users",
  }
}