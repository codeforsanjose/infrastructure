resource "aws_iam_user" "gha_user" {
  name = "github-action"

  tags = var.tags
}


resource "aws_iam_access_key" "gha_keys" {
  user = aws_iam_user.gha_user.name
}

resource "aws_iam_user_policy" "gha_policy" {
  name = "github_action_policy"
  user = aws_iam_user.gha_user.name

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "iam:PassRole"
            ],
            "Resource": [
                "arn:aws:iam::${var.account_id}:role/ecsServiceRole",
                "arn:aws:iam::${var.account_id}:role/ecsTaskExecutionRole"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
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
                "ecr:CreateRepository"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}

output access_key_id {
  value = aws_iam_access_key.gha_keys.id
}

output secret_access_key_id {
  value = aws_iam_access_key.gha_keys.secret
}

// TODO: Potential Limit Github Action User to only certain resources, not necesary, but optional
//   policy = <<EOF
// {
//    "Version":"2012-10-17",
//    "Statement":[
//       {
//          "Sid":"RegisterTaskDefinition",
//          "Effect":"Allow",
//          "Action":[
//             "ecs:RegisterTaskDefinition"
//          ],
//          "Resource":"*"
//       },
//       {
//          "Sid":"PassRolesInTaskDefinition",
//          "Effect":"Allow",
//          "Action":[
//             "iam:PassRole"
//          ],
//          "Resource":[
//             "arn:aws:iam::${var.account_d}:role/<task_definition_task_role_name>",
//             "arn:aws:iam::${var.account_d}:role/<task_definition_task_execution_role_name>"
//          ]
//       },
//       {
//          "Sid":"DeployService",
//          "Effect":"Allow",
//          "Action":[
//             "ecs:UpdateService",
//             "ecs:DescribeServices"
//          ],
//          "Resource":[
//             "arn:aws:ecs:<region>:${var.account_d}:service/<cluster_name>/<service_name>"
//          ]
//       }
//    ]
// }
// EOF