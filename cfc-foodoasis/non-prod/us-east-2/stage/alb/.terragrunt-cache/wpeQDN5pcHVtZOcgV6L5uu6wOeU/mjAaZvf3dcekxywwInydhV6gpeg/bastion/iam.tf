resource "aws_iam_instance_profile" "s3_readonly" {
  // name_prefix = "s3_ro"
  name = "bastion_s3_read_only_profile"
  role        = aws_iam_role.s3_readonly.name
}

resource "aws_iam_role" "s3_readonly" {
  // name_prefix = "s3_readonly"
  name = "bastion_s3_readonly_role"
  path        = "/"

  assume_role_policy = <<EOF
{
  "Version"  : "2012-10-17",
  "Statement": [
    {
      "Sid"      : "",
      "Effect"   : "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

data "aws_iam_policy_document" "s3_readonly_policy" {
  statement {
    sid     = "S3ReadOnlyPublicKey"
    actions = [
      "s3:List*",
      "s3:Get*",
      "ec2:AssociateAddress"
    ]
    resources = [aws_s3_bucket.ssh_public_keys.arn, "*"]
  }
}

resource "aws_iam_role_policy" "s3_readonly_policy" {
  // name_prefix = "s3_readonly-policy"
  name = "bastion_s3_readonly_policy"
  role        = aws_iam_role.s3_readonly.id

  policy = data.aws_iam_policy_document.s3_readonly_policy.json
}