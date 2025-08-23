# Staging Environment Configuration
# File: Examples/staging.tfvars
# Use with: terraform apply -var-file=Examples/staging.tfvars

# AWS Configuration
aws_region = "us-west-2"

# Project Configuration
project_name = "day7-state-mgmt-staging"
environment  = "staging"

# State Backend Configuration
state_bucket_prefix = "terraform-state-bucket-staging"
dynamodb_table_name = "terraform-state-lock-staging"

# Infrastructure Configuration
instance_count = 2
instance_type  = "t3.small"

# Security Configuration
allowed_cidr_blocks = [
  "10.0.0.0/16",    # VPC internal
  "192.168.0.0/16", # Corporate network
  "172.16.0.0/12"   # VPN network
]

# Monitoring Configuration
enable_detailed_monitoring = true

# VPC Configuration
vpc_cidr = "10.1.0.0/16"

# Staging-specific settings
# These settings balance cost and production-like behavior

# Additional staging-specific configurations
# - Higher instance count for load testing
# - Detailed monitoring enabled
# - Production-like security policies
# - Separate network addressing