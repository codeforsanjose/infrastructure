locals {
  envname = "${var.project_name}-${var.environment}"
}

variable "project_name" {
  type    = string
}

variable "environment" {
  type    = string
}

variable "vpc_id" {
  type    = string
}

variable "vpc_cidr" {
  type    = string
  default = "10.1.0.0/16"
}

variable "public_subnet_ids" {
  type    = list(string)
}

variable "ecs_ec2_instance_count" {
  type = number
  default = 0
}

variable "alb_security_group_id" {
  type = string
}