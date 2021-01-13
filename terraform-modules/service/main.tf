data "template_file" "task_definition" {
  template = file("${path.module}/templates/task-definition.json")
  vars     = {
    account_id       = var.account_id
    environment      = var.environment
    project_name     = var.project_name
    region           = var.region

    cluster_name     = var.cluster_name
    task_name        = var.task_name
    container_memory = var.container_memory
    container_cpu    = var.container_cpu
    container_port   = var.container_port
    container_name   = var.container_name

    // TODO: Use remote Docker Image Repository
    image       = "nginxdemos/hello"

    # Secrets injected securely from AWS SSM systems manager param store
    # https://docs.aws.amazon.com/systems-manager/latest/userguide/systems-manager-parameter-store.html
    # token_secret      = data.aws_ssm_parameter.token_secret.arn
    // db_hostname       = var.aws_ssm_db_hostname_arn
    // postgres_password = var.aws_ssm_db_password_arn
  }
}


resource "aws_ecs_task_definition" "task" {
  family = var.task_name

  container_definitions    = data.template_file.task_definition.rendered
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  memory                   = var.container_memory
  cpu                      = var.container_cpu
  execution_role_arn       = aws_iam_role.task_exec_role.arn
  task_role_arn            = aws_iam_role.task_exec_role.arn
  // container_name           = var.container_name
}

resource "aws_ecs_service" "svc" {
  name            = var.task_name
  cluster         = var.cluster_id
  task_definition = aws_ecs_task_definition.task.arn
  launch_type     = "FARGATE"
  desired_count   = var.desired_count

  load_balancer {
    container_name   = var.container_name
    container_port   = var.container_port
    target_group_arn = var.alb_target_group_arn
  }

  network_configuration {
    subnets          = var.public_subnet_ids
    security_groups  = [aws_security_group.svc_sg.id, var.bastion_security_group_id]
    //     security_groups  = [aws_security_group.svc_sg.id, var.db_security_group_id, var.bastion_security_group_id]
    assign_public_ip = true
  }
}
