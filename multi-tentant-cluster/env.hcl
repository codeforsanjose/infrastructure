locals {
  environment = "dev"
  domain_name = "codeforsanjose.org"

  // ecs
  ecs_ec2_instance_count = 1
  ecs_ec2_instance_type = "t3.small"

  tags = { terraform_managed = "true" }
}