variable region {
  type = string
}

variable availability_zones {
  type = list(string)
}

variable namespace {
  type = string
}

variable name {
  type = string
}

variable environment {
  type = string
}

variable cidr_block { type = string }

variable tags {
  default = { terraform_managed = "true" }
  type    = map
}