locals {
  # State bucket configuration
  state_bucket_name = aws_s3_bucket.terraform_state.bucket

  # Backend configuration for easy reference
  backend_config = {
    bucket         = local.state_bucket_name
    key            = "day7/terraform.tfstate"
    region         = var.aws_region
    encrypt        = true
    dynamodb_table = aws_dynamodb_table.terraform_state_lock.name
  }

  # VPC CIDR configuration
  vpc_cidr = var.vpc_cidr

  # Instance information mapping
  instance_info = {
    for idx, instance in aws_instance.test_instances :
    "instance-${idx + 1}" => {
      id                = instance.id
      public_ip         = instance.public_ip
      private_ip        = instance.private_ip
      availability_zone = instance.availability_zone
      subnet_id         = instance.subnet_id
      instance_type     = instance.instance_type
      web_url           = "http://${instance.public_ip}"
      health_check_url  = "http://${instance.public_ip}/health"
    }
  }

  # Common tags for all resources
  common_tags = {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "Terraform"
    Day         = "7"
    Purpose     = "State Management Demo"
    Owner       = data.aws_caller_identity.current.user_id
    Region      = data.aws_region.current.name
  }

  # Environment-specific configurations
  environment_config = {
    dev = {
      backup_retention_days = 30
      enable_monitoring     = false
      instance_protection   = false
    }
    staging = {
      backup_retention_days = 60
      enable_monitoring     = true
      instance_protection   = false
    }
    production = {
      backup_retention_days = 365
      enable_monitoring     = true
      instance_protection   = true
    }
  }

  current_env_config = local.environment_config[var.environment]
}
