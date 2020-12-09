// --------------------------
// General/Global Variables
// --------------------------
variable project_name {
  description = "The overall name of the project using this infrastructure; used to group related resources by"
}

variable vpc_id {
  description = "VPC ID"
}

variable environment {
  description = "a short name describing the lifecyle or stage of development that this is running for; ex: 'dev', 'qa', 'prod', 'test'"
}
variable region {
  description = "the aws region code where this is deployed; ex: 'us-west-2', 'us-east-1', 'us-east-2'"
}

variable private_subnet_cidrs {
  description = "private subnet cidrs from where to place the RDS instance"
  type = list(string)
}

variable private_subnet_ids {
  description = "private subnet ids from where to place the RDS instance"
    type = list(string)
}

variable tags {
  default = { terraform_managed = "true" }
  type    = map
}

variable datetime {
  description = "Contains string of the datetime when terraform created the resource"
}

// --------------------------
// Database Variables
// --------------------------
variable db_username {
  description = "The name of the default postgres user created by RDS when the instance is booted"
}

variable db_name {
  description = "The name of the default postgres database created by RDS when the instance is booted"
}
variable db_password {
  description = "The postgres database password created for the default database when the instance is booted"
}

variable db_port {
  description = "database port"
}

variable db_instance_class {
  description = "The instance type of the db; defaults to db.t2.small"
  default     = "db.t2.small"
}
variable db_engine_version {
  description = "the database major and minor version of postgres; default to 11.8"
  default     = "11.8"
}
variable db_allow_major_engine_version_upgrade {
  default = true
}

variable db_major_version {
  default = "11"
}


// --------------------------
// Migration Variables
// --------------------------
variable db_instance_id_migration {
  description = "The database ID from which the new database will start using the latest snapshot"
  default = "empty"
}

variable db_instance_region_migration {
  description = "The database ID from which the new database will start using the latest snapshot"
  default = "empty"
}

variable db_snapshot_migration {
  description = "Name of snapshot that will used to for new database"
}

variable db_migration_flag {
  description = "Flag to determine if new RDS instance will pull data from snapshot"
  default     = 1
}


// Bastion SG
variable bastion_security_group_id {
  description = "bastion sg id to allow connection to rds"
}
