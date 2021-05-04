locals {
  environment = "prod"

  // ALB
  default_alb_url = "codeforsanjose.org"

  // Amazon Certificate Manager
  // Hardcoding pre-created certificate to avoid reaching limit https://github.com/aws/aws-cdk/issues/5889
  domain_names = ["codeforsanjose.org"]

  // Route 53 Records - That will point to the ALB
  // host_names = ["fight.foodoasis.net"]
  host_names = []

  // ECS
  ecs_ec2_instance_count = 1
  ecs_ec2_instance_type  = "t3.small"

  // Bastion
  bastion_hostname = "bastion.codeforsanjose.org"
  github_file = {
    github_repo_owner = "codeforsanjose",
    github_repo_name  = "Infrastructure",
    github_branch     = "main",
    github_filepath   = "bastion_github_users",
  }

  // Global tags
  tags = { terraform_managed = "true", last_changed = formatdate("EEE YYYY-MMM-DD hh:mm:ss", timestamp()) }
}
