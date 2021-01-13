resource "aws_lb" "alb" {
  name               = "${var.project_name}-${var.environment}-lb"
  load_balancer_type = "application"
  subnets            = var.public_subnet_ids
  security_groups    = [aws_security_group.alb.id]
  tags               = merge({ Name = var.project_name }, var.tags)
}

resource "aws_security_group" "alb" {
  name_prefix = var.project_name
  description = "load balancer sg for ingress and egress to ${var.project_name}-${var.environment} containers"
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
  ssl_policy        = "ELBSecurityPolicy-TLS-1-2-Ext-2018-06"
  certificate_arn   = var.acm_certificate_arn

  default_action {
    type = "redirect"
    
    redirect {
      host        = "www.codeforsanjose.org"
      path        = "/"
      query       = ""
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}