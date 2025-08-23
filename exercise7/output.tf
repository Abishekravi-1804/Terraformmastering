# State Backend Outputs
output "state_bucket_name" {
  description = "Name of the S3 bucket storing Terraform state"
  value       = aws_s3_bucket.terraform_state.bucket
}

output "state_bucket_arn" {
  description = "ARN of the S3 bucket storing Terraform state"
  value       = aws_s3_bucket.terraform_state.arn
}

output "state_bucket_region" {
  description = "Region of the S3 bucket"
  value       = data.aws_region.current.name
}

output "dynamodb_table_name" {
  description = "Name of the DynamoDB table for state locking"
  value       = aws_dynamodb_table.terraform_state_lock.name
}

output "dynamodb_table_arn" {
  description = "ARN of the DynamoDB table for state locking"
  value       = aws_dynamodb_table.terraform_state_lock.arn
}

output "backend_configuration" {
  description = "Backend configuration for remote state"
  value       = local.backend_config
}

output "terraform_state_policy_arn" {
  description = "ARN of the IAM policy for Terraform state access"
  value       = aws_iam_policy.terraform_state_access.arn
}

# Infrastructure Outputs
output "test_vpc_id" {
  description = "ID of the test VPC"
  value       = aws_vpc.test_vpc.id
}

output "test_vpc_cidr" {
  description = "CIDR block of the test VPC"
  value       = aws_vpc.test_vpc.cidr_block
}

output "test_subnet_ids" {
  description = "IDs of the test subnets"
  value       = aws_subnet.test_subnet[*].id
}

output "test_instance_details" {
  description = "Details of test EC2 instances"
  value       = local.instance_info
}

output "test_instance_public_ips" {
  description = "Public IP addresses of test instances"
  value       = aws_instance.test_instances[*].public_ip
}

output "test_instance_private_ips" {
  description = "Private IP addresses of test instances"
  value       = aws_instance.test_instances[*].private_ip
}

output "security_group_id" {
  description = "ID of the test security group"
  value       = aws_security_group.test_sg.id
}

output "internet_gateway_id" {
  description = "ID of the internet gateway"
  value       = aws_internet_gateway.test_igw.id
}

# Migration and Setup Outputs
output "migration_commands" {
  description = "Commands to migrate to remote state backend"
  value = {
    step1 = "# Update main.tf to uncomment the backend configuration"
    step2 = "terraform init"
    step3 = "# Answer 'yes' when prompted to copy state to remote backend"
    step4 = "terraform plan  # Verify no changes after migration"
  }
}

output "web_urls" {
  description = "URLs to access the test web servers"
  value = [
    for ip in aws_instance.test_instances[*].public_ip : "http://${ip}"
  ]
}

output "deployment_info" {
  description = "Deployment information"
  value = {
    project_name    = var.project_name
    environment     = var.environment
    aws_region      = var.aws_region
    instance_count  = var.instance_count
    instance_type   = var.instance_type
    aws_account_id  = data.aws_caller_identity.current.account_id
    deployment_time = timestamp()
  }
}
