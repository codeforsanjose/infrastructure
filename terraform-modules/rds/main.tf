// terraform {
//   # Live modules pin exact Terraform version; generic modules let consumers pin the version.
//   # The latest version of Terragrunt (v0.25.1 and above) recommends Terraform 0.13.3 or above.
//   required_version = "= 0.13.5"

//   # Live modules pin exact provider version; generic modules let consumers pin the version.
//   required_providers {
//     aws = {
//       source  = "hashicorp/aws"
//       version = "= 3.20.0"
//     }
//   }
// }

resource "aws_security_group" "db" {
  name = "${var.project_name}-${var.environment}-database"
  description = "Ingress and egress for ${var.db_name} RDS"
  vpc_id      = var.vpc_id
  tags        = merge({ Name = var.db_name }, var.tags)

  ingress {
    description = "db ingress from private subnets"
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = var.private_subnet_cidrs
  }

  # allow ingress from bastion server
  ingress {
    description     = "inbound from bastion server"
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [var.bastion_security_group_id]
  }

  egress {
    description = "db egress to private subnets"
    self        = true
    from_port   = 22
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = var.private_subnet_cidrs
  }
}

// TODO(1/2): Add Conditional using var.db_migration_flag
// Pull latest existing snapshot for DB
// data "aws_db_snapshot" "latest_db_snapshot" {
//   db_instance_identifier = var.db_instance_id_migration
//   most_recent            = true
// }
// resource "aws_db_snapshot" "test" {
//   db_instance_identifier = var.db_instance_id_migration
//   db_snapshot_identifier = "terraform-migration"
//   tags                   = merge(var.tags, var.datetime)
// }

module "db" {
  source     = "terraform-aws-modules/rds/aws"
  // https://registry.terraform.io/modules/terraform-aws-modules/rds/aws/2.20.0
  // version    = "~> 2.0"
  version    = "~> 2.20.0"
  identifier = "${var.project_name}-${var.environment}"

  allow_major_version_upgrade = var.db_allow_major_engine_version_upgrade
  engine                      = "postgres"
  engine_version              = var.db_engine_version
  instance_class              = var.db_instance_class
  allocated_storage           = 20

  // db_subnet_group_name ="${var.project_name}-${var.environment}-subnet_group"
  // parameter_group_name = "${var.project_name}-${var.environment}-param_group"
  // option_group_name = "${var.project_name}-${var.environment}-option_group"

  name     = var.db_name
  username = var.db_username
  password = var.db_password
  port     = var.db_port

  // TODO(2/2): Add Conditional using var.db_migration_flag
  // snapshot_identifier = data.aws_db_snapshot.latest_db_snapshot.id
  snapshot_identifier = var.db_snapshot_migration

  vpc_security_group_ids = [aws_security_group.db.id]

  maintenance_window = "Mon:00:00-Mon:03:00"
  backup_window      = "03:00-06:00"

  # disable backups to create DB faster
  backup_retention_period = 0

  tags = var.tags

  enabled_cloudwatch_logs_exports = ["postgresql", "upgrade"]

  # DB subnet group
  subnet_ids = var.private_subnet_ids

  # DB parameter group
  family = "postgres${var.db_major_version}"

  # DB option group
  major_engine_version = var.db_major_version

  # Database Deletion Protection
  deletion_protection = false
  
}
