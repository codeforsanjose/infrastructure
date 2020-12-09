output "security_group_id" {
  description = "the security group id of the bastion server. Add this id to other services that run within the vpc to which you want to access externally."
  value       = module.bastion.security_group_id
}

output "bastion_asg_id" {
  description = "The auto-scaling group id of the bastion server"
  value       = module.bastion.asg_id
}

output "eip_public_address" {
  description = "the public ip address of the Elastic IP fronting the bastion server"
  value       = aws_eip.eip.public_ip
}

output bastion_ssh_public_keys_bucket {
  description = "The name of the bucket where the bastion server gets its allowed public keys. Copy new users RSA public key to this bucket in order to grant them SSH access to the bastion."
  value       = aws_s3_bucket.ssh_public_keys.id
}