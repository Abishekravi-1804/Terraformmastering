
aws_region   = "ap-south-1"
project_name = "day7-state-mgmt"
environment  = "dev"

# State backend configuration
state_bucket_prefix = "terraform-state-bucket"
dynamodb_table_name = "terraform-state-lock"

# Test infrastructure
instance_count = 2
instance_type  = "t2.micro"

# Security
allowed_cidr_blocks        = ["10.0.0.0/16"]
enable_detailed_monitoring = false
