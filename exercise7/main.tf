terraform {
backend "s3" {
   }
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Project     = "Terraform-Mastery-Day7"
      Environment = var.environment
      ManagedBy   = "Terraform"
      Day         = "7"
    
    }
  }
}

# Generate unique suffix for globally unique resources
resource "random_string" "bucket_suffix" {
  length  = 8
  special = false
  upper   = false
}

# S3 bucket for Terraform state storage
resource "aws_s3_bucket" "terraform_state" {
  bucket        = "${var.state_bucket_prefix}-${random_string.bucket_suffix.result}"
  force_destroy = var.environment == "dev" ? true : false

  tags = {
    Name       = "Terraform State Store"
    Purpose    = "Remote State Backend"
    Encryption = "AES256"
  }
}

# Enable versioning on the S3 bucket
resource "aws_s3_bucket_versioning" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Configure server-side encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
    bucket_key_enabled = true
  }
}

# Block public access to the bucket
resource "aws_s3_bucket_public_access_block" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Configure lifecycle policy for cost optimization
resource "aws_s3_bucket_lifecycle_configuration" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id

  rule {
    id     = "terraform_state_lifecycle"
    status = "Enabled"

    # ADD this filter block
    filter {
      prefix = ""
    }

    # Move non-current versions to IA after 30 days
    noncurrent_version_transition {
      noncurrent_days = 30
      storage_class   = "STANDARD_IA"
    }

    # Delete non-current versions after 90 days
    noncurrent_version_expiration {
      noncurrent_days = 90
    }

    # Delete incomplete multipart uploads after 7 days
    abort_incomplete_multipart_upload {
      days_after_initiation = 7
    }
  }
}

# DynamoDB table for state locking
resource "aws_dynamodb_table" "terraform_state_lock" {
  name         = var.dynamodb_table_name
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  # Enable point-in-time recovery for production
  point_in_time_recovery {
    enabled = var.environment == "production" ? true : false
  }

  # Enable server-side encryption
  server_side_encryption {
    enabled = true
  }

  tags = {
    Name       = "Terraform State Lock Table"
    Purpose    = "State Locking Mechanism"
    Encryption = "AWS Managed"
  }
}

# IAM policy for Terraform state access
resource "aws_iam_policy" "terraform_state_access" {
  name        = "${var.project_name}-terraform-state-access"
  description = "Policy for Terraform state bucket and DynamoDB access"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowStateS3Access"
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject",
          "s3:ListBucket",
          "s3:GetObjectVersion"
        ]
        Resource = [
          aws_s3_bucket.terraform_state.arn,
          "${aws_s3_bucket.terraform_state.arn}/*"
        ]
      },
      {
        Sid    = "AllowStateLockDynamoDBAccess"
        Effect = "Allow"
        Action = [
          "dynamodb:GetItem",
          "dynamodb:PutItem",
          "dynamodb:DeleteItem"
        ]
        Resource = aws_dynamodb_table.terraform_state_lock.arn
      }
    ]
  })

  tags = {
    Name    = "Terraform State Access Policy"
    Purpose = "Enable state backend operations"
  }
}

# Test infrastructure to demonstrate state management
resource "aws_vpc" "test_vpc" {
  cidr_block           = local.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name    = "${var.project_name}-test-vpc"
    Purpose = "Demonstrate state management"
  }
}

resource "aws_subnet" "test_subnet" {
  count = 2

  vpc_id                  = aws_vpc.test_vpc.id
  cidr_block              = cidrsubnet(local.vpc_cidr, 8, count.index + 1)
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name    = "${var.project_name}-test-subnet-${count.index + 1}"
    Purpose = "Demonstrate state management"
    Type    = "Public"
  }
}

resource "aws_internet_gateway" "test_igw" {
  vpc_id = aws_vpc.test_vpc.id

  tags = {
    Name    = "${var.project_name}-test-igw"
    Purpose = "Demonstrate state management"
  }
}

resource "aws_route_table" "test_rt" {
  vpc_id = aws_vpc.test_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.test_igw.id
  }

  tags = {
    Name    = "${var.project_name}-test-rt"
    Purpose = "Demonstrate state management"
  }
}

resource "aws_route_table_association" "test_rta" {
  count = length(aws_subnet.test_subnet)

  subnet_id      = aws_subnet.test_subnet[count.index].id
  route_table_id = aws_route_table.test_rt.id
}

resource "aws_security_group" "test_sg" {
  name_prefix = "${var.project_name}-test-sg"
  description = "Test security group for state management demo"
  vpc_id      = aws_vpc.test_vpc.id

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.allowed_cidr_blocks
  }

  egress {
    description = "All outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name    = "${var.project_name}-test-sg"
    Purpose = "Demonstrate state management"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_instance" "test_instances" {
  count = var.instance_count

  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.test_subnet[count.index % length(aws_subnet.test_subnet)].id
  vpc_security_group_ids = [aws_security_group.test_sg.id]
  monitoring             = var.enable_detailed_monitoring

  user_data = base64encode(templatefile("${path.module}/userdata.sh", {
    instance_number = count.index + 1
    project_name    = var.project_name
    environment     = var.environment
  }))

  tags = {
    Name    = "${var.project_name}-test-instance-${count.index + 1}"
    Purpose = "Demonstrate state management"
    Index   = count.index + 1
  }

  lifecycle {
    create_before_destroy = true
  }
}

# Data sources
data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

data "aws_caller_identity" "current" {}

data "aws_region" "current" {}
