locals {
  environment = "dev"
  domain_name = "codeforsanjose.org"

  // ecs
  ecs_ec2_instance_count = 1

  tags = { terraform_managed = "true" }
}