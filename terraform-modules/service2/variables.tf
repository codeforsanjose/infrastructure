locals {
  envname                = "${var.project_name}-${var.environment}"
  ecs_service_name       = "${var.project_name}-${var.environment}-service"
  task_definition_family = "${var.project_name}-${var.environment}-td"
  task_name              = "${var.project_name}-${var.environment}-task"
  container_name         = "${var.project_name}-${var.environment}-container"
}
// --------------------------
// Global/General Variables
// --------------------------
variable account_id {
  description = "AWS Account ID"
}

variable project_name {
  description = "The overall name of the project using this infrastructure; used to group related resources by"
}

variable region {
  type    = string
  default = "us-east-2"
}

variable environment {
  type = string
}

variable "host_name" {
  type = string
}

variable "vpc_id" {
  description = "VPC ID"
}

variable tags {
  default = { terraform_managed = "true" }
  type    = map
}

// --------------------------
// ECS/Fargat Variables
// --------------------------

variable "asg_capacity_prov" {
  type = string
}
variable container_cpu {
  type    = number
  default = 256
}

variable container_memory {
  type    = number
  default = 512
}

variable container_port {
  type    = number
  default = 80
}

variable health_check_path {
  type    = string
  default = "/"
}

variable "cluster_id" {
  type = string
}

variable cluster_name {
  type = string
}

variable desired_count {
  default = 1
  type    = number
}

variable public_subnet_ids {
  description = "VPB Public Subnets for where to place Fargate tasks"
  type        = list(string)
}

variable "alb_target_group_arn" {
  description = "ALB Target group for where to place task definitions"
}

variable "alb_https_listener_arn" {
  description = "ALB https listener arn for adding rule to"
}

