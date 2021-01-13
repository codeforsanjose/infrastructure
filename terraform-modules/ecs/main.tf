resource "aws_ecs_cluster" "cluster" {
  name = "${local.envname}-cluster"

  capacity_providers = ["EC2"]

  default_capacity_provider_strategy {
    capacity_provider = "EC2"
    weight            = 100
  }

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

// resource "aws_ecs_capacity_provider" "prov1" {
//   name = "prov1"

//   auto_scaling_group_provider {
//     auto_scaling_group_arn = module.asg.this_autoscaling_group_arn
//     // auto_scaling_group_arn = "arn:aws:autoscaling:us-west-1:253016134262:autoScalingGroup:667d50a7-3dc8-45b3-99b0-8a9f3059b996:autoScalingGroupName/multi-tenant-dev-20210111060237207900000002"
//   }

// }

resource "aws_service_discovery_private_dns_namespace" "private_dns_ns" {
  name        = local.envname
  description = "Terraform Service Discovery"
  vpc         = var.vpc_id
}
