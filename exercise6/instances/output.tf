output "bastion_public_ip" {
  description = "Public IP of the bastion host"
  value       = aws_instance.vpc1_bastion.public_ip
}

output "web_instances_private_ips" {
  description = "Private IPs of web instances"
  value       = aws_instance.vpc2_web[*].private_ip
}

output "database_instance_private_ip" {
  description = "Private IP of database instance"
  value       = aws_instance.vpc1_database.private_ip
}
