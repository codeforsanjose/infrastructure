data "template_file" "task_definition" {
  template = file("${path.module}/templates/task-definition.json")
  vars     = {
    region           = var.region
    cluster_name     = var.cluster_name

    container_memory = var.container_memory
    container_cpu    = var.container_cpu
    container_port   = var.container_port

    container_name   = local.container_name
    task_name        = local.task_name

    // TODO: Use remote ECR/DockerHub Image Repository
    image = "nginxdemos/hello"
  }
}

resource "aws_ecs_task_definition" "task" {
  family = local.task_definition_family

  container_definitions    = data.template_file.task_definition.rendered
  requires_compatibilities = ["EC2"]
  network_mode             = "bridge"
  memory                   = var.container_memory
  cpu                      = var.container_cpu
}

resource "aws_ecs_service" "svc" {
  name = local.ecs_service_name
  cluster         = var.cluster_id
  task_definition = aws_ecs_task_definition.task.arn
  launch_type     = "EC2"
  desired_count   = var.desired_count

  load_balancer {
    container_name   = local.container_name
    container_port   = 80
    target_group_arn = aws_lb_target_group.this.arn
  }

  depends_on = [aws_lb_target_group.this, aws_lb_listener_rule.static]
}

resource "aws_lb_target_group" "this" {
  name     = "${local.envname}-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
}

resource "aws_lb_listener_rule" "static" {
  listener_arn = var.alb_https_listener_arn
  priority     = 1

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this.arn
  }

  condition {
    host_header {
      values = [var.host_name]
    }
  }

  depends_on = [aws_lb_target_group.this]
}