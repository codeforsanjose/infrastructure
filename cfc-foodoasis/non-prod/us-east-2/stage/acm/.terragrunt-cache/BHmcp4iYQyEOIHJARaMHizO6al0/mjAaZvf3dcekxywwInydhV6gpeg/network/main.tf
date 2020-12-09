// terraform {
//   # Live modules pin exact Terraform version; generic modules let consumers pin the version.
//   # The latest version of Terragrunt (v0.25.1 and above) recommends Terraform 0.13.3 or above.
//   required_version = "= 0.13.5"

//   # Live modules pin exact provider version; generic modules let consumers pin the version.
//   required_providers {
//     aws = {
//       source  = "hashicorp/aws"
//       version = "= 3.20.0"
//     }
//   }
// }

// Module starter code: https://github.com/jafow/terraform-modules/tree/master/aws-blueprints/network
module "vpc" {
  source     = "git::https://github.com/cloudposse/terraform-aws-vpc.git?ref=0.18.0"
  namespace  = var.namespace
  stage      = var.environment
  name       = var.name
  cidr_block = var.cidr_block
}

module "subnets" {
  source               = "git::https://github.com/cloudposse/terraform-aws-dynamic-subnets.git?ref=tags/0.32.0"
  availability_zones   = var.availability_zones
  namespace            = var.namespace
  stage                = var.environment
  name                 = var.name
  vpc_id               = module.vpc.vpc_id
  igw_id               = module.vpc.igw_id
  cidr_block           = module.vpc.vpc_cidr_block
  nat_gateway_enabled  = false
  nat_instance_enabled = false
}