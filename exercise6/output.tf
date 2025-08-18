output "vpc2_vpc_id" {
  description = "VPC ID for VPC2 "
  value       = module.vpc2.vpc_id
}

output "vpc1_vpc_id" {
  description = "VPC ID for VPC1 "
  value       = module.vpc1.vpc_id
}

output "peering_connection_id" {
  description = "VPC Peering Connection ID"
  value       = module.peering.peering_connection_id
}

output "private_key_pem" {
  description = "Private key in PEM format"
  value       = module.keypair.private_key_pem
  sensitive   = true
}

output "public_key_openssh" {
  description = "Public key in OpenSSH format"
  value       = module.keypair.public_key_openssh
}

output "key_pair_name" {
  description = "Key pair name"
  value       = module.keypair.key_name
}

output "bastion_public_ip" {
  description = "Public IP of the bastion host"
  value       = module.instances.bastion_public_ip
}

output "web_instances_private_ips" {
  description = "Private IPs of web instances"
  value       = module.instances.web_instances_private_ips
}

output "database_instance_private_ip" {
  description = "Private IP of database instance"
  value       = module.instances.database_instance_private_ip
}


