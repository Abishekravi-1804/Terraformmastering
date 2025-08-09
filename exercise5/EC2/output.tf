output "bastion_public_ip" {
  description = "Public IP address of the bastion host"
  value       = aws_instance.bastion.public_ip
}

output "bastion_private_ip" {
  description = "Private IP address of the bastion host"
  value       = aws_instance.bastion.private_ip
}

output "bastion_instance_id" {
  description = "Instance ID of the bastion host"
  value       = aws_instance.bastion.id
}

output "private_key_pem" {
  description = "Private key in PEM format"
  value       = tls_private_key.generated_key.private_key_pem
  sensitive   = true
}

output "key_pair_name" {
  description = "Name of the generated key pair"
  value       = aws_key_pair.generated.key_name
}
