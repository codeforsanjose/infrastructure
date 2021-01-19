locals {

  environment  = "dev"
  domain_name  = "codeforsanjose.org"
  host_name    = "meal-tally.codeforsanjose.org"
  project_name = "meal-tally"

  // Container variables
  container_image  = "253016134262.dkr.ecr.us-west-1.amazonaws.com/mealtally-redis:latest"
  desired_count    = 1
  container_port   = 8080
  container_memory = 0
  container_cpu    = 0
  container_env_vars = [
    {
      "name": "SESSION_SECRET",
      "value": "MAmtk4aFmjLr353R"
    },
    {
      "name": "DB_NAME",
      "value": "mealtally_ver2"
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
    }
  ]
}
