output "bastion_public_ip" {
  value = module.ec2.bastion_public_ip
}

output "app_private_ip" {
  value = module.ec2.app_private_ip
}

output "private_key_pem" {
  value     = module.ec2.private_key_pem
  sensitive = true
}

output "public_key_openssh" {
  value = module.ec2.public_key_openssh
}