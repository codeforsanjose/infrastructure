// --------------------------
// Global/General Variables
// --------------------------
variable "account_id" {
  description = "AWS Account ID"
}

variable "vpc_id" {
  description = "VPC ID"
}

variable "tags" {
  default = { terraform_managed = "true" }
  type    = map
}

// --------------------------
// Security Group Variables
// --------------------------
variable "allowed_cidr" {
  type = list(string)

  default = [
    "0.0.0.0/0",
  ]

  description = "A list of CIDR Networks to allow ssh access to."
}

variable "allowed_ipv6_cidr" {
  type = list(string)

  default = [
    "::/0",
  ]

  description = "A list of IPv6 CIDR Networks to allow ssh access to."
}

variable "allowed_security_groups" {
  type        = list(string)
  default     = []
  description = "A list of Security Group ID's to allow access to."
}

// --------------------------
// Bastion Instance Variables
// --------------------------
variable "bastion_name" {
  description = "Name given to the Bastion Server in tags.Name"
  type = string
}

variable "bastion_instance_type" {
  description = "The ec2 instance type of the bastion server"
  default     = "t2.micro"
}

variable "public_subnet_ids" {
  description = "public subnet ids for where to place bastion"
  type        = list(string)
}

variable "key_name" {
  description = "SSH key to be added as the default AMI user"
  type = string
  default = ""
}

// --------------------------
// User_Data.sh Variables
// --------------------------
variable "ssh_user" {
  default = "ubuntu"
}

variable "github_file" {
  type = map(string)
}

// variable "github_repo_owner" {
//   type = string
// }

// variable "github_repo_name" {
//   type = string
// }

// variable "github_branch" {
//   type = string
// }

// variable "github_filepath" {
//   type = string
// }

variable "enable_hourly_cron_updates" {
  default = "false"
}

variable "cron_key_update_schedule" {
  default     = "5,0,*,* * * * *"
  description = "The cron schedule that public keys are synced from the bastion s3 bucket to the server; default to once every hour"
}

variable "additional_user_data_script" {
  default     = ""
}