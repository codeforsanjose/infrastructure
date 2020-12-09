// General
account_id   = 470363915259
project_name = "foodoasis"
environment        = "dev"

region             = "us-east-2"
availability_zones = ["us-east-2a", "us-east-2c" ]

domain_name = "foodoasis.net"
host_name = "aws-test.foodoasis.net"

tags = { terraform_managed = "true" }

// Container
health_check_path = "/health"
container_port = 5000

// Datbase
db_name     = "foodoasisdev"
db_password = "quokkafola"
db_username = "postgres"
db_port     = 5432

db_instance_id_migration     = "foodoasis"
db_instance_region_migration = "us-east-2"

db_snapshot_migration        = "terraform-migration-1"

// Bastion
bastion_name         = "bastion"
ssh_public_key_names = ["darren"]