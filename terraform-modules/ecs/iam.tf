resource "aws_iam_role" "ecs_task_execution_role" {
  name        = "${local.envname}-ecs-task-role"
  description = "Allow ECS tasks to access AWS resources"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      },
    ]
  })

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "ecs_task" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_instance_profile" "ecs-instance" {
  name = "${local.envname}-profile"
  role = aws_iam_role.ecs-instance-role.name
}

resource "aws_iam_role" "ecs-instance-role" {
  name = "${local.envname}-ecs_instance"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ecs-instance-role-attachment" {
  role       = aws_iam_role.ecs-instance-role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

data "external" "lookup" {
  program = ["/bin/bash", "ecs-service-role-lookup.sh"]
  // provisioner "local-exec" {
  //   command = "export response=$(aws iam get-role --role-name AWSServiceRoleForECS --output text) > /dev/null 2>&1 ; if [[ $response == '' ]]; then export TF_VAR_CREATE_SERVICE_ECS_ROLE=true ; fi "
  //   interpreter = ["/bin/bash"]
  // }
}
