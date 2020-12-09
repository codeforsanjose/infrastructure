provider "aws" {
  version = "3.20.0"
  region  = var.region
}

module "network" {
  source             = "./network"
  region             = var.region
  namespace          = var.namespace
  environment              = var.environment
  name               = "${var.project_name}-${var.environment}vpc"
  cidr_block         = var.cidr_block
  availability_zones = var.availability_zones
}

module "rds" {
  source = "./rds"

  project_name = var.project_name
  environment        = var.environment
  region       = var.region
  datetime     = local.datetime

  db_username = var.db_username
  db_name     = var.db_name
  db_password = var.db_password
  db_port     = var.db_port

  // Use either instance to pull latest snaphsot for DB
  // !! Does not currently work if AWS Provider is in a different region
  db_instance_id_migration     = var.db_instance_id_migration
  db_instance_region_migration = var.db_instance_region_migration

  // OR specify snapshot directly
  db_snapshot_migration = var.db_snapshot_migration

  // Module Network variables
  vpc_id                    = module.network.vpc_id
  private_subnet_ids        = module.network.private_subnet_ids
  private_subnet_cidrs      = module.network.private_subnet_cidrs
  bastion_security_group_id = module.bastion.security_group_id
}

module "applicationlb" {
  source = "./applicationlb"

  // Input from other Modules
  vpc_id            = module.network.vpc_id
  public_subnet_ids = module.network.public_subnet_ids
  acm_certificate_arn = module.r53.acm_certificate_arn

  // Input from Variables
  account_id = var.account_id
  region     = var.region
  environment      = var.environment
  project_name = var.project_name

  // Container Variables
  container_port = var.container_port
  task_name      = local.task_name
  tags           = var.tags
}

module "ecs" {
  source = "./ecs-fargate"

  // Input from other Modules
  vpc_id                    = module.network.vpc_id
  public_subnet_ids         = module.network.public_subnet_ids
  db_security_group_id      = module.rds.db_security_group_id
  bastion_security_group_id = module.bastion.security_group_id
  aws_ssm_db_hostname_arn   = module.rds.aws_ssm_db_hostname_arn
  aws_ssm_db_password_arn   = module.rds.aws_ssm_db_password_arn
  alb_security_group_id     = module.applicationlb.security_group_id
  alb_target_group_arn      = module.applicationlb.alb_target_group_arn

  // Input from Variables
  account_id = var.account_id
  region     = var.region
  environment      = var.environment
  project_name = var.project_name

  // Container Variables
  desired_count    = var.desired_count
  container_memory = var.container_memory
  container_cpu    = var.container_cpu
  container_port   = var.container_port
  container_name   = local.container_name
  cluster_name     = local.cluster_name
  task_name        = local.task_name
  image_tag        = var.image_tag

  depends_on = [ module.applicationlb ]
}

module "r53" {
  source = "./r53-https"

  // Input from other Modules
  alb_external_dns  = module.applicationlb.lb_dns_name
  alb_arn = module.applicationlb.lb_arn
  alb_target_group_arn = module.applicationlb.target_group_arn

  // Input from Variables
  domain_name = var.domain_name
  host_name = var.host_name
}

module "bastion" {
  source = "./bastion"

  // Input from other Modules
  vpc_id            = module.network.vpc_id
  public_subnet_ids = module.network.public_subnet_ids

  // Input from Variables
  account_id = var.account_id
  region     = var.region

  bastion_name             = "bastion-${var.project_name}-${var.environment}"
  bastion_instance_type    = var.bastion_instance_type
  cron_key_update_schedule = var.cron_key_update_schedule
  ssh_public_key_names     = var.ssh_public_key_names
}

module "github_action" {
  source = "./github_action"
}