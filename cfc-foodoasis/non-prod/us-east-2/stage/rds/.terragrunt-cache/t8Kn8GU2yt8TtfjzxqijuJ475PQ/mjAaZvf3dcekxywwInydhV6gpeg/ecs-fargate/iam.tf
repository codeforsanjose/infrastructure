data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "logs" {
  statement {
    actions = [
      "logs:AssumeRole",
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]
    resources = ["*"]
  }
  statement {
    sid     = "SSMRead"
    actions = [
      "ssm:Get*"
    ]
    resources = ["arn:aws:ssm:${var.region}:${var.account_id}:parameter/${var.project_name}/${var.environment}/*"]
  }
}

resource "aws_iam_policy" "logs" {
  // name_prefix = substr(var.task_name, 0, 6)
  name        = "${var.project_name}-${var.environment}-task-cw-logs"
  description = "ecs logs permission"
  policy      = data.aws_iam_policy_document.logs.json
}

resource "aws_iam_role_policy_attachment" "task_exec_role_policy" {
  role       = aws_iam_role.task_exec_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role_policy_attachment" "logs" {
  role       = aws_iam_role.task_exec_role.name
  policy_arn = aws_iam_policy.logs.arn
}

resource "aws_iam_role" "task_exec_role" {
  name_prefix        = substr("task-${var.task_name}", 0, 6)
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
}