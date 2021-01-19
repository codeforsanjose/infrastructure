locals {

  environment  = "dev"
  domain_name  = "codeforsanjose.org"
  host_name    = "disaster-reponse.codeforsanjose.org"
  project_name = "disaster-response-client"

  // Container variables
  container_image  = "253016134262.dkr.ecr.us-west-1.amazonaws.com/disaster-response-client:latest"
  desired_count    = 1
  container_port   = 80
  container_memory = 0
  container_cpu    = 0
  container_env_vars = [
    {
      "name": "SESSION_SECRET",
      "value": "MAmtk4aFmjLr353R"
    },
    {
      "name": "MONGODB_URI",
      "value": 
    },
    {
      "name": "NODE_ENV",
      "value": "production"
    },
    {
      "name": "REDIS_PORT",
      "value": "6379"
    },
    {
      "name": "REDIS_URL",
      "value": "redis.multi-tenant-dev"
    },
    {
      "name": "PROD_API_URL",
      "value": "disaster-response.codeforsanjose.com"
    },
    {
    "name": "PROD_API_PORT",
    "value": "443"
    }
  ]
}