# Backend configuration for Day 7 State Management
# This file contains the configuration for the remote state backend
# Use this file with: terraform init -backend-config=Examples/backend-config.hcl

# S3 bucket for state storage
bucket = "terraform-state-bucket-unique-12345"

# State file path within the bucket
key = "day7/terraform.tfstate"

# AWS region where the bucket is located
region = "ap-south-1"

# Enable encryption for state file
encrypt = true

# DynamoDB table for state locking
dynamodb_table = "terraform-state-lock"

# Optional: Workspace key prefix (uncomment if using workspaces)
# workspace_key_prefix = "environments"

# Optional: Server-side encryption configuration
# kms_key_id = "arn:aws:kms:us-west-2:123456789012:key/12345678-1234-1234-1234-123456789012"

# Optional: Role to assume for backend operations
# role_arn = "arn:aws:iam::123456789012:role/TerraformBackendRole"

# Optional: External ID for role assumption
# external_id = "unique-external-id"

# Optional: Session name for assumed role
# session_name = "TerraformBackendSession"

# Optional: Skip credentials validation
# skip_credentials_validation = false

# Optional: Skip region validation
# skip_region_validation = false

# Optional: Skip metadata API check
# skip_metadata_api_check = false

# Optional: Force path style for S3 URLs
# force_path_style = false

# Team Notes:
# - Replace bucket name with your actual state bucket
# - Ensure all team members have IAM permissions for this bucket and DynamoDB table
# - Keep this file updated when backend configuration changes
# - Do not commit AWS credentials to version control