// data "template_file" "task_definition" {
//   template = file("${path.module}/templates/task-definition.json")
//   vars     = {
//     // account_id       = var.account_id
//     // environment      = var.environment
//     // project_name     = var.project_name
//     region           = var.region

//     cluster_name     = var.cluster_name
//     task_name        = var.task_name
//     container_memory = var.container_memory
//     container_cpu    = var.container_cpu
//     container_port   = var.container_port
//     container_name   = var.container_name

//     // TODO: Use remote ECR/DockerHub Image Repository
//     image = "nginxdemos/hello"

//     # Secrets injected securely from AWS SSM systems manager param store
//     # https: //docs.aws.amazon.com/systems-manager/latest/userguide/systems-manager-parameter-store.html
//     # token_secret = data.aws_ssm_parameter.token_secret.arn
//     // db_hostname       = var.aws_ssm_db_hostname_arn
//     // postgres_password = var.aws_ssm_db_password_arn
//   }
// }

resource "aws_ecs_task_definition" "task" {
  family = "terraform-test1"

  // container_definitions    = data.template_file.task_definition.rendered
  container_definitions = file("td.json")
  requires_compatibilities = ["EC2"]
  network_mode             = "bridge"
  memory                   = var.container_memory
  cpu                      = var.container_cpu
  execution_role_arn       = "arn:aws:iam::253016134262:role/ecsTaskExecutionRole"
  task_role_arn            = "arn:aws:iam::253016134262:role/ecsTaskExecutionRole"
}

resource "aws_ecs_service" "svc" {
  name            = var.task_name
  // name = "${var.project_name}-service"
  cluster         = var.cluster_id
  iam_role = "ecsServiceRole"
  task_definition = aws_ecs_task_definition.task.arn
  launch_type     = "EC2"
  desired_count   = var.desired_count

  load_balancer {
    // container_name   = var.container_name
    container_name = "test-container-name"
    container_port   = 443
    target_group_arn = var.alb_target_group_arn
  }

  network_configuration {
    subnets         = var.public_subnet_ids
    // security_groups = [aws_security_group.svc_sg.id, var.bastion_security_group_id]
    //     security_groups  = [aws_security_group.svc_sg.id, var.db_security_group_id, var.bastion_security_group_id]
  }
}

resource "aws_lb_target_group" "test" {
  name     = "${var.project_name}-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
}

// resource "aws_lb_listener_rule" "static" {
//   listener_arn = "arn:aws:elasticloadbalancing:us-west-1:253016134262:listener/app/cfsj-application-load-balancer/5428ac1b63d4e1c5/ea4ada376e38ceb8"
//   priority     = 100

//   action {
//     type             = "forward"
//     target_group_arn = var.alb_target_group_arn
//   }

//   condition {
//     host_header {
//       values = ["terraform-test.codeforsanjose.com"]
//     }
//   }
// }




// data "aws_iam_policy_document" "ecs_service" {
//   statement {
//     actions = ["sts:AssumeRole"]

//     principals {
//       type        = "Service"
//       identifiers = ["ecs.amazonaws.com"]
//     }
//   }
// }

// resource "aws_iam_service_linked_role" "ecs-service" {
//   aws_service_name = "ecs.amazonaws.com"
// }

// resource "aws_iam_role" "ecs_service_role" {
//   name        = "${var.project_name}-${var.environment}-ecs-service"
//   // name_prefix        = substr("task-${var.task_name}", 0, 6)
//   assume_role_policy = data.aws_iam_policy_document.ecs_service.json
// }

// data "aws_iam_policy" "ecs-service" {
//   arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceRole"
// }

// resource "aws_iam_role_policy_attachment" "test-attach" {
//   role       = aws_iam_service_linked_role.ecs-service.name
//   policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceRole"
// }

// resource "aws_iam_policy" "policy" {
//   name        = "EC2ContainerServiceRole"
//   path        = "/"
//   description = "My test policy"

//   policy = <<EOF
// {
//     "Version": "2012-10-17",
//     "Statement": [
//         {
//             "Effect": "Allow",
//             "Action": [
//                 "ec2:AuthorizeSecurityGroupIngress",
//                 "ec2:Describe*",
//                 "elasticloadbalancing:DeregisterInstancesFromLoadBalancer",
//                 "elasticloadbalancing:DeregisterTargets",
//                 "elasticloadbalancing:Describe*",
//                 "elasticloadbalancing:RegisterInstancesWithLoadBalancer",
//                 "elasticloadbalancing:RegisterTargets"
//             ],
//             "Resource": "*"
//         }
//     ]
// }
// EOF
// }