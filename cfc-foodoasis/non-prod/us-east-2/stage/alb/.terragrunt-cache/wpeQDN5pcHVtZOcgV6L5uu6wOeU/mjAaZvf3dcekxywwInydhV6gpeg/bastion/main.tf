// terraform {
//   # Live modules pin exact Terraform version; generic modules let consumers pin the version.
//   # The latest version of Terragrunt (v0.25.1 and above) recommends Terraform 0.13.3 or above.
//   required_version = "= 0.13.5"

//   # Live modules pin exact provider version; generic modules let consumers pin the version.
//   required_providers {
//     aws = {
//       source  = "hashicorp/aws"
//       version = "= 3.20.0"
//     }
//   }
// }
module "bastion" {
  source                      = "git::https://github.com/terraform-community-modules/tf_aws_bastion_s3_keys?ref=tags/v2.0.0"
  instance_type               = var.bastion_instance_type
  ami                         = data.aws_ami.ami.id
  eip                         = aws_eip.eip.public_ip
  region                      = var.region
  iam_instance_profile        = aws_iam_instance_profile.s3_readonly.name
  s3_bucket_name              = aws_s3_bucket.ssh_public_keys.id
  vpc_id                      = var.vpc_id
  // subnet_ids                  = tolist(var.public_subnet_ids)
  subnet_ids                  = var.public_subnet_ids
  keys_update_frequency       = var.cron_key_update_schedule
  enable_hourly_cron_updates  = true
  apply_changes_immediately   = true
  associate_public_ip_address = true
  ssh_user                    = "ec2-user"
  additional_user_data_script = <<EOF
  printf "============================\n"
  printf "============================\n"
  printf "============================\n"
  printf "============================\n"
  REGION=$(curl -s http://169.254.169.254/latest/dynamic/instance-identity/document | grep region | awk -F\" '{print $4}')
  INSTANCE_ID=$(curl -s http://169.254.169.254/latest/meta-data/instance-id)
  aws ec2 associate-address --region $REGION --instance-id $INSTANCE_ID --allocation-id ${aws_eip.eip.id}
  EOF
}

data "aws_ami" "ami" {
  owners      = ["137112412989"]
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn-ami-hvm*.x86_64-ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
}

resource "aws_eip" "eip" {
  vpc = true
}
