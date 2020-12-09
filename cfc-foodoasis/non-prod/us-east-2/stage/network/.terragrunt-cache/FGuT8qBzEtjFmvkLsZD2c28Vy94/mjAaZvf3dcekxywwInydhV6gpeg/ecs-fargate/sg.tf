resource "aws_security_group" "svc_sg" {
  // name_prefix = "bn-loadbalancer"
  name = "${var.project_name}-${var.environment}-alb-sg"
  description = "inbound from load balancer to ecs service"

  vpc_id = var.vpc_id

  ingress {
    description     = "inbound from load balancer"
    from_port       = var.container_port
    to_port         = var.container_port
    protocol        = "tcp"
    security_groups = [var.alb_security_group_id]
    self            = true
  }
  ingress {
    description     = "inbound ssh from bastion"
    from_port       = 20
    to_port         = 22
    protocol        = "tcp"
    security_groups = [var.bastion_security_group_id]
    self            = true
  }
  egress {
    description     = "outbound traffic to the world"
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    security_groups = [var.alb_security_group_id]
    cidr_blocks     = ["0.0.0.0/0"]
  }
  tags = merge({ Name = "ecs-service-sg" }, var.tags)
}
