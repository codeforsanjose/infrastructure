variable account_id {
  description = "AWS Account ID"
}

variable region {
  type        = string
  default     = "us-east-2"
}

variable vpc_id {
  description = "VPC ID"
}

variable public_subnet_ids {
  description = "public subnet ids for where to place bastion"
  type = list(string)
}

variable bastion_name {
  type        = string
}

variable bastion_instance_type {
  description = "The ec2 instance type of the bastion server"
  default     = "t2.micro"
}

variable cron_key_update_schedule {
  default     = "5,0,*,* * * * *"
  description = "The cron schedule that public keys are synced from the bastion s3 bucket to the server; default to once every hour"
}

variable ssh_public_key_names {
  description = "the name of the public key files in ./public_keys without the file extension; example ['alice', 'bob', 'carol']"
  type        = list(string)
}