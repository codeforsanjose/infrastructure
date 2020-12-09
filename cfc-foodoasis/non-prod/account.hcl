# Set account-wide variables. These are automatically pulled in to configure the remote state bucket in the root
# terragrunt.hcl configuration.
locals {
  account_name   = "DarrentPham"
  aws_account_id = "470363915259"
  aws_profile    = "default"
  namespace      = "cfc"
  project_name   = "food-oasis"
  domain_name    = "foodoasis.net"
  host_name      = "aws-test.foodoasis.net"

  // datetime is going to be added to tags for terraform creation date
  datetime     = { date_processed = formatdate("YYYYMMDDhhmmss", timestamp()) }

  bastion_instance_type    = "t2.micro"
  cron_key_update_schedule = "5,0,*,* * * * *"
  ssh_public_key_names     = []
}