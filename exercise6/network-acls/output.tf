output "vpc2_public_nacl_id" {
  description = "VPC2 (Production) public NACL ID"
  value       = aws_network_acl.vpc2_public.id
}

output "vpc2_private_nacl_id" {
  description = "VPC2 (Production) private NACL ID"
  value       = aws_network_acl.vpc2_private.id
}

output "vpc1_private_nacl_id" {
  description = "VPC1 (Management) private NACL ID"
  value       = aws_network_acl.vpc1_private.id
}
