// Save DB parameters into SSM for use by Task Definition
resource "aws_ssm_parameter" "db_hostname" {
  name        = "/${var.project_name}/${var.environment}/DB_HOSTNAME"
  description = "database hostname"
  type        = "SecureString"
  value       = module.db.this_db_instance_endpoint
  overwrite   = true

  tags = var.tags
}

resource "aws_ssm_parameter" "db_password" {
  name        = "/${var.project_name}/${var.environment}/DB_PASSWORD"
  description = "database password"
  type        = "SecureString"
  value       = var.db_password
  overwrite   = true

  tags = var.tags
}

resource "aws_ssm_parameter" "db_user" {
  name        = "/${var.project_name}/${var.environment}/DB_USER"
  description = "database username"
  type        = "SecureString"
  value       = var.db_username
  overwrite   = true

  tags = var.tags
}

resource "aws_ssm_parameter" "db_name" {
  name        = "/${var.project_name}/${var.environment}/DB_NAME"
  description = "database name"
  type        = "SecureString"
  value       = var.db_name
  overwrite   = true

  tags = var.tags
}

resource "aws_ssm_parameter" "db_port" {
  name        = "/${var.project_name}/${var.environment}/DB_PORT"
  description = "database port"
  type        = "SecureString"
  value       = var.db_port
  overwrite   = true

  tags = var.tags
}