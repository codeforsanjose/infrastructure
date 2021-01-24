locals {
  project_name = "open-disclosure-api"
  environment  = "dev"
  domain_name  = "codeforsanjose.org"
  host_name    = "open-disclosure.codeforsanjose.org"
  url_path     = "/open-disclosure/api"

  // Container variables
  container_image  = "253016134262.dkr.ecr.us-west-1.amazonaws.com/open-disclosure-backend:latest"
  desired_count    = 1
  container_port   = 5000
  container_memory = 0
  container_cpu    = 0
  container_env_vars = [
    {
      "name": "FLASK_APP",
      "value": "api"
    },
    {
      "name": "REDIS_API_PORT",
      "value": "6379"
    },
    {
      "name": "REDIS_API_URL",
      "value": "redis.multi-tenant-dev"
    },
    {
      "name": "FLASK_RUN_HOST",
      "value": "0.0.0.0"
    }
  ]
}