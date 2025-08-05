
output "private_key_pem" {
  description = "Private SSH key to connect to Bastion and private instances"
  value       = tls_private_key.generated_key.private_key_pem
  sensitive   = true
}


output "public_key_openssh" {
  description = "Public SSH key "
  value       = tls_private_key.generated_key.public_key_openssh
}

output "bastion_public_ip" {
  description = "Public IP of Bastion Host"
  value       = aws_instance.bastion.public_ip
}


output "app_private_ip" {
  description = "Private IP of the app server in private subnet"
  value       = aws_instance.app.private_ip
}
