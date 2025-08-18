output "private_key_pem" {
  description = "Private key in PEM format"
  value       = tls_private_key.generated_key.private_key_pem
  sensitive   = true
}

output "public_key_openssh" {
  description = "Public key in OpenSSH format"
  value       = tls_private_key.generated_key.public_key_openssh
}

output "key_name" {
  description = "AWS key pair name"
  value       = aws_key_pair.generated.key_name
}
