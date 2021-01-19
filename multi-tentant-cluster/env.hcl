locals {
  environment = "dev"
  domain_name = "codeforsanjose.org"

  // ecs
  ecs_ec2_instance_count = 1
  ecs_ec2_instance_type = "t3.small"

  // redis - 0 means unrestricted and sets memoryReservation = 85
  redis_container_memory      = 0
  redis_container_cpu         = 0

  tags = { terraform_managed = "true" }
}