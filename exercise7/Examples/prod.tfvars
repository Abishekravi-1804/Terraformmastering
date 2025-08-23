# Production Environment Configuration
# File: Examples/prod.tfvars
# Use with: terraform apply -var-file=Examples/prod.tfvars

# AWS Configuration
aws_region = "us-west-2"

# Project Configuration
project_name = "day7-state-mgmt-prod"
environment  = "production"

# State Backend Configuration
state_bucket_prefix = "terraform-state-bucket-prod"
dynamodb_table_name = "terraform-state-lock-prod"

# Infrastructure Configuration
instance_count = 3
instance_type  = "t3.medium"

# Security Configuration - Restricted access for production
allowed_cidr_blocks = [
  "10.0.0.0/16" # VPC internal only
]

# Monitoring Configuration
enable_detailed_monitoring = true

# VPC Configuration
vpc_cidr = "10.2.0.0/16"

# Production-specific settings
# These settings optimize for reliability, security, and performance

# Production hardening notes:
# - Minimal external access
# - Detailed monitoring enabled
# - Higher capacity instances
# - Separate network space
# - Enhanced security posture

# Additional production considerations:
# - Enable deletion protection on critical resources
# - Implement backup and recovery procedures
# - Set up alerting and monitoring
# - Review and audit access regularly