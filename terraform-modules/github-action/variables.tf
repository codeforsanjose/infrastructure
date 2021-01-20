variable "tags" {
  default = { terraform_managed = "true" }
  type    = map
}

variable "account_id" {
  type = string
}