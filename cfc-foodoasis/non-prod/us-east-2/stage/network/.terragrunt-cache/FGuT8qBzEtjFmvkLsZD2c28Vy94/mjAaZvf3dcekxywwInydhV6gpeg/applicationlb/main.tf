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

# application load balancer 
locals {
  name = "${var.environment}-${var.task_name}"
}

resource "aws_lb" "alb" {
  name               = "${var.project_name}-lb"
  load_balancer_type = "application"
  subnets            = var.public_subnet_ids
  security_groups    = [aws_security_group.alb.id]
  tags               = merge({ Name = var.project_name }, var.tags)
}

resource "aws_security_group" "alb" {
  name_prefix = var.project_name
  description = "load balancer sg for ingress and egress to ${var.task_name}"
  vpc_id      = var.vpc_id

  tags = merge({ Name = var.project_name }, var.tags)

  ingress {
    description = "HTTP from world"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS from world"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

   egress {
     description = "allow outbound traffic to the world"
     from_port   = 0
     to_port     = 0
     protocol    = "-1"
     cidr_blocks = ["0.0.0.0/0"]
     self        = true
   }
}

// Used if no certificate is available, will forward over 80 with no HTTP
// resource "aws_lb_listener" "http" {
//   load_balancer_arn = aws_lb.alb.arn
//   port              = 80
//   protocol          = "HTTP"

//   default_action {
//     type             = "forward"
//     target_group_arn = aws_lb_target_group.default.arn
//    }
// }

resource "aws_lb_listener" "http_redirect" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_lb_listener" "ssl" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = var.acm_certificate_arn
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.default.arn
  }
}

resource "aws_lb_target_group" "default" {
  // name_prefix          = substr(local.name, 0, 6)
  name = "${var.project_name}-${var.environment}-tg"
  port                 = var.container_port
  protocol             = "HTTP"
  deregistration_delay = 100
  target_type          = "ip"
  vpc_id               = var.vpc_id

  health_check {
		enabled             = true
		healthy_threshold   = 5
		interval            = 30
		path                = "/health"
		port                = "traffic-port"
		protocol            = "HTTP"
		timeout             = 10
		unhealthy_threshold = 3
  }
}
