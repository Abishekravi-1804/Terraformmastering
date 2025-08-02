terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}


provider "aws" {
  region = var.aws_region
}


#Bucketname  with prefix and owner details with environment 

resource "aws_s3_bucket" "my_first_bucket" {
  bucket = "${var.bucket_prefix}-${random_string.suffix.result}"

  tags = {
    Name        = var.bucket_prefix
    Environment = var.environment
    Owner       = var.owner

  }
}

#Bucket policy 

data "aws_iam_policy_document" "private_bucket_policy" {
  statement {
    sid    = "AllowOwnerFullAccess"
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${var.root_account_id}:root"]
    }
    actions = [
      "s3:*",
    ]
    resources = [
      aws_s3_bucket.my_first_bucket.arn,
      "${aws_s3_bucket.my_first_bucket.arn}/*",
    ]
  }
}

resource "aws_s3_bucket_policy" "private_policy" {
  bucket = aws_s3_bucket.my_first_bucket.id
  policy = data.aws_iam_policy_document.private_bucket_policy.json
  depends_on = [aws_s3_bucket.my_first_bucket]
}

resource "aws_s3_bucket_public_access_block" "example" {
  bucket = aws_s3_bucket.my_first_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "random_string" "suffix" {
  length  = 8
  special = false
  upper   = false
}

resource "aws_s3_bucket_versioning" "versioning_example" {
  bucket = aws_s3_bucket.my_first_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_kms_key" "mykey" {
  description             = var.kms_description
  deletion_window_in_days = 10
}

resource "aws_s3_bucket_server_side_encryption_configuration" "example" {
  bucket = aws_s3_bucket.my_first_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.mykey.arn
      sse_algorithm     = "aws:kms"

    }

  }
}
