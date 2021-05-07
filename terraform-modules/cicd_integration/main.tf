data "aws_caller_identity" "current" {}

resource "aws_iam_user" "gha_user" {
  name = format("%s-github-user", local.envname)

  tags = var.tags
}

resource "aws_iam_access_key" "gha_keys" {
  user = aws_iam_user.gha_user.name
}

resource "aws_iam_user_policy" "gha_policy" {
  name = format("%s-github-user", local.envname)
  user = aws_iam_user.gha_user.name

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "ecs:RegisterTaskDefinition",
          "ecs:DescribeTaskDefinition",
          "ecs:UpdateService",
          "ecs:DescribeServices",
          "ecr:CompleteLayerUpload",
          "ecr:GetAuthorizationToken",
          "ecr:UploadLayerPart",
          "ecr:InitiateLayerUpload",
          "ecr:BatchCheckLayerAvailability",
          "ecr:PutImage",
          "ecr:ListImages",
          "ecr:CreateRepository",
          "autoscaling:UpdateAutoScalingGroup"
        ],
        Resource = "*"
      },
      {
        Effect = "Allow",
        Action = [
          "iam:PassRole"
        ],
        Resource = [
          var.default_ecs_service_role_arn,
          var.execution_role_arn
        ]
      }
    ]
  })
}

output "access_key_id" {
  value     = aws_iam_access_key.gha_keys.id
  sensitive = false
}

output "secret_access_key_id" {
  value     = aws_iam_access_key.gha_keys.secret
  sensitive = false
}
