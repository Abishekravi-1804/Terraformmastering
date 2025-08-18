output "vpc_id" {
  description = "VPC1 ID"
  value       = aws_vpc.vpc1.id
}

output "public_subnet_ids" {
  description = "VPC1 public subnet IDs"
  value       = aws_subnet.vpc1_public[*].id
}

output "private_subnet_ids" {
  description = "VPC1 private subnet IDs"
  value       = aws_subnet.vpc1_private[*].id
}

output "route_table_ids" {
  description = "VPC1 route table IDs"
  value       = [aws_route_table.vpc1_public.id, aws_route_table.vpc1_private.id]
}

output "bastion_security_group_id" {
  description = "VPC1 bastion security group ID"
  value       = aws_security_group.vpc1_bastion.id
}

output "database_security_group_id" {
  description = "VPC1 database security group ID"
  value       = aws_security_group.vpc1_database.id
}
