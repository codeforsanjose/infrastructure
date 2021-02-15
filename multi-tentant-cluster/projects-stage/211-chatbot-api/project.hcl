locals {
  project_name = "211-chatbot"
  environment  = "stage"
  domain_name  = "codeforsanjose.org"
  host_name    = "211-chatbot-stage.codeforsanjose.org"
  url_path     = ""
  // health_check_path = "assets/modules/channel-web/default.css"

  // Container variables
  container_image  = "botpress/server:v12_14_1" # default botpress image
  desired_count    = 1
  container_port   = 3000
  container_memory = 0
  container_cpu    = 0
  container_env_vars = []
}