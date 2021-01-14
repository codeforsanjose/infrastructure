locals {

  environment = "dev"
  domain_name = "codeforsanjose.org"
  host_names  = [""]

  // Container env vars
  desired_count    = 1
  container_memory = 512
  container_cpu    = 256

}
