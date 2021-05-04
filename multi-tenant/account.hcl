# Set account-wide variables. These are automatically pulled in to configure the remote state bucket in the root
# terragrunt.hcl configuration.
locals {
  aws_region    = "us-west-2"
  namespace     = "cfsj"
  resource_name = "multi-tenant"

  # Pre-created AWS Resources:
  # S3 Bucket for storing Terragrunt/Terraform State files
  s3_terragrunt_region = "us-west-1"
  s3_terragrunt_bucket = "codeforsanjose-terraform"
  # DynamoDB Table for storing lock files to avoid collision
  dynamodb_terraform_lock = "terraform-locks"
  # EC2 SSH Key
  key_name = "cfsj-ecs-cluster-prod" #TODO: Make optional
}
