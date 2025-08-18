output "vpc_id" {
  description = "VPC2 ID"
  value       = aws_vpc.vpc2.id
}

output "public_subnet_ids" {
  description = "VPC2 public subnet IDs"
  value       = aws_subnet.vpc2_public[*].id
}

output "private_subnet_ids" {
  description = "VPC2 private subnet IDs"
  value       = aws_subnet.vpc2_private[*].id
}

output "private_route_table_id" {
  description = "VPC2 private route table ID"
  value       = aws_route_table.vpc2_private.id
}

output "web_security_group_id" {
  description = "VPC2 web security group ID"
  value       = aws_security_group.vpc2_web.id
}
