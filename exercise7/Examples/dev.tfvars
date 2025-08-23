# Development Environment Configuration
# File: Examples/dev.tfvars
# Use with: terraform apply -var-file=Examples/dev.tfvars

# AWS Configuration
aws_region = "us-west-2"

# Project Configuration
project_name = "day7-state-mgmt-dev"
environment  = "dev"

# State Backend Configuration
state_bucket_prefix = "terraform-state-bucket-dev"
dynamodb_table_name = "terraform-state-lock-dev"

# Infrastructure Configuration
instance_count = 1
instance_type  = "t3.micro"

# Security Configuration
allowed_cidr_blocks = [
  "10.0.0.0/16",   # VPC internal
  "192.168.1.0/24" # Office network
]

# Monitoring Configuration
enable_detailed_monitoring = false

# VPC Configuration
vpc_cidr = "10.0.0.0/16"

# Development-specific settings
# These settings optimize for cost and development workflows

# Tags for development resources
# Note: Additional tags are automatically applied via default_tags in main.tf