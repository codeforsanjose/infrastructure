resource "aws_s3_bucket" "ssh_public_keys" {
  bucket        = "${var.bastion_name}-keys"
  acl           = "private"
  force_destroy = true

  policy = <<EOF
{
	"Version": "2008-10-17",
	"Id": "${var.bastion_name}-Policy",
	"Statement": [
		{
			"Sid": "GetPublicKeys",
			"Effect": "Allow",
			"Principal": {
				"AWS": [
				  "arn:aws:iam::${var.account_id}:root"
        ]
			},
			"Action": [
				"s3:List*",
				"s3:Get*"
			],
			"Resource": "arn:aws:s3:::${var.bastion_name}-keys"
		}
	]
}
EOF
}

resource "aws_s3_bucket_object" "ssh_public_keys" {
  count = length(var.ssh_public_key_names)

  bucket = aws_s3_bucket.ssh_public_keys.bucket
  key    = "${element(var.ssh_public_key_names, count.index)}.pub"

  # Make sure that you put files into correct location and name them accordingly (`public_keys/{keyname}.pub`)
  source = "public_keys/${element(var.ssh_public_key_names, count.index)}.pub"

  depends_on = [aws_s3_bucket.ssh_public_keys]
}
