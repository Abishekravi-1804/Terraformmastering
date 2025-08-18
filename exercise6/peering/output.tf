output "peering_connection_id" {
  description = "VPC Peering connection ID"
  value       = aws_vpc_peering_connection.vpc2_to_vpc1.id
}
