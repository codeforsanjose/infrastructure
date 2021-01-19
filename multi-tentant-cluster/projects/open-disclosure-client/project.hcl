locals {

  environment  = "dev"
  domain_name  = "codeforsanjose.org"
  host_name    = "open-disclosure.codeforsanjose.org"
  project_name = "open-disclosure-client"

  // Container variables
  container_image  = "253016134262.dkr.ecr.us-west-1.amazonaws.com/open-disclosure-frontend:latest"
  desired_count    = 1
  container_port   = 80
  container_memory = 0
  container_cpu    = 0
  container_env_vars = [
    {
      "name": "NODE_ENV",
      "value": "production"
    },
    {
      "name": "PROD_API_PORT",
      "value": "8080"
    },
    {
      "name": "PROD_API_URL",
      "value": "open-disclosure-api-dev.multi-tenant-dev"
    }
  ]
}