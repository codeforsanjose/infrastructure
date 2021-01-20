locals {
  environment = "dev"
  domain_name = "codeforsanjose.org"

  // ecs
  ecs_ec2_instance_count = 1
  ecs_ec2_instance_type = "t3.small"

  // redis - 0 means unrestricted and sets memoryReservation = 85
  redis_container_memory      = 0
  redis_container_cpu         = 0

  // Bastion
  cron_key_update_schedule = "5,0,*,* * * * *"
  
  github_file              = {
    github_repo_owner = "codeforsanjose",
    github_repo_name  = "Infrastructure",
    github_branch     = "main",
    github_filepath   = "bastion_github_users",
  }

  // Global tags
  tags = { terraform_managed = "true", last_changed = formatdate("EEE YYYY-MMM-DD hh:mm:ss", timestamp()) }
}