variable account_id {
  description = "AWS Account ID"
}

variable resource_name {
  description = "The overall name of the project using this infrastructure; used to group related resources by"
}

variable vpc_id {
  description = "VPC ID"
}

variable region {
  type    = string
}

variable environment {
  type    = string
}

variable tags {
  default = { terraform_managed = "true" }
  type    = map
}

variable public_subnet_ids {
  description = "Public Subnets for where the ALB will be associated with"
  type = list(string)
}

variable acm_certificate_arn {
  description = "Certificate to use for HTTPS listener"
}