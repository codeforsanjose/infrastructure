data "aws_ami" "amazon_linux_ecs" {
  most_recent = true

  owners = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn-ami-*-amazon-ecs-optimized"]
  }

  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }
}

module "asg" {
  // https://registry.terraform.io/modules/terraform-aws-modules/autoscaling/aws/3.8.0
  source  = "terraform-aws-modules/autoscaling/aws"
  version = "3.8.0"

  count = var.ecs_ec2_instance_count

  name = "${local.envname}-${count.index}"

  # Launch configuration
  lc_name = local.envname

  image_id             = data.aws_ami.amazon_linux_ecs.id
  instance_type        = "t2.micro"
  security_groups      = [aws_security_group.allow_tls.id]
  iam_instance_profile = aws_iam_instance_profile.this.id
  user_data            = data.template_file.user_data.rendered

  # Auto scaling group
  asg_name                  = local.envname
  vpc_zone_identifier       = var.private_subnet_ids
  health_check_type         = "EC2"
  min_size                  = 0
  max_size                  = 2
  desired_capacity          = var.ecs_ec2_instance_count
  wait_for_capacity_timeout = 0

  tags = [
    {
      key                 = "Environment"
      value               = var.environment
      propagate_at_launch = true
    },
    {
      key                 = "Cluster"
      value               = aws_ecs_cluster.cluster.name
      propagate_at_launch = true
    },
  ]
}

data "template_file" "user_data" {
  template = file("${path.module}/templates/user-data.sh")

  vars = {
    cluster_name = aws_ecs_cluster.cluster.name
  }
}

resource "aws_security_group" "allow_tls" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic"
  vpc_id      = var.vpc_id

  ingress {
    description = "TLS from VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = var.vpc_cidr
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_tls"
  }
}