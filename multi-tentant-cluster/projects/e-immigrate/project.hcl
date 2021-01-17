locals {

  environment  = "dev"
  domain_name  = "codeforsanjose.org"
  host_name    = "terraform-test.codeforsanjose.com"
  project_name = "test-app"

  // Container env vars
  desired_count         = 1
  reserved_compute_bool = true
  container_port        = 80
  container_memory      = 512
  container_cpu         = 256
}
