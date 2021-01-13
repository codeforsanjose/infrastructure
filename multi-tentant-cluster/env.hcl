locals {

  environment = "dev"
  domain_name = "codeforsanjose.org"
  host_names  = [""]

  // ecs
  ecs_ec2_instance_count = 1
  
  // Container env vars
  desired_count    = 1
  container_port   = 5000
  container_memory = 512
  container_cpu    = 256

  // db_username = ""
  // db_name     = var.db_name
  // db_password = var.db_password

  // Use either instance to pull latest snaphsot for DB
  // !! Does not currently work if AWS Provider is in a different region
  // db_instance_id_migration     = 
  // db_instance_region_migration = 

  // OR specify snapshot directly
  db_snapshot_migration = "terraform-migration-1"

  tags = { terraform_managed = "true" }
}