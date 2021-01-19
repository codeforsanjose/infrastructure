locals {

  environment  = "dev"
  domain_name  = "codeforsanjose.org"
  host_name    = "ciit.codeforsanjose.org"
  project_name = "e-immigrate-client"

  // Container variables
  container_image  = "253016134262.dkr.ecr.us-west-1.amazonaws.com/e-immigrate:b263e5987cb3db04114a0296ff67bdd981041f9d"
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
      "value": "e-immigrate-api.corp"
    }
  ]
}
