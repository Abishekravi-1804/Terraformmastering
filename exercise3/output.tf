output "instance_public_ip" {
  value       = aws_instance.dev_instance.public_ip
  description = "EC2 instance public IP"
}

output "instance_id" {
  value       = aws_instance.dev_instance.id
  description = "EC2 instance ID"
}

output "security_group_id" {
  value       = aws_security_group.dev_sg.id
  description = "Security group ID"
}


