
output "bastion_public_ip" {
  description = "Public IP address of the bastion host"
  value       = module.ec2.bastion_public_ip
}

output "bastion_private_ip" {
  description = "Private IP address of the bastion host"
  value       = module.ec2.bastion_private_ip
}


output "private_key_pem" {
  description = "Private key in PEM format for SSH access"
  value       = module.ec2.private_key_pem
  sensitive   = true
}


output "alb_dns_name" {
  description = "DNS name of the Application Load Balancer"
  value       = module.autoscaling.alb_dns_name
}


output "vpc_id" {
  description = "ID of the VPC"
  value       = module.vpc.vpc_id
}


output "ssh_instructions" {
  description = "Instructions for SSH access"
  value       = <<-EOT
    To connect to your infrastructure:
    
    1. Save the private key:
       terraform output -raw private_key_pem > private_key.pem
       chmod 600 private_key.pem
    
    2. SSH to bastion host:
       ssh -i private_key.pem ubuntu@${module.ec2.bastion_public_ip}
    
    3. From bastion, SSH to private instances:
       ssh -i ~/.ssh/private_key.pem ubuntu@<private-instance-ip>
    
    4. Access your application:
       curl http://${module.autoscaling.alb_dns_name}
  EOT
}
