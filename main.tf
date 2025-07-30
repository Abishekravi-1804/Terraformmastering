terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}


provider "aws" {
  region = "ap-south-1"
}



resource "aws_s3_bucket" "my_first_bucket" {
    bucket = "my-terraform-learning-bucket-${random_string.suffix.result}"

    tags = {
    Name        = "my_first_bucket"
    Environment = "Dev"
    Owner = " Abishek "

  }
}


data "aws_iam_policy_document" "private_bucket_policy" {
  statement {
    sid    = "AllowOwnerFullAccess"
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::<my_IAM_ID>:root"]
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
  description             = "This key is used to encrypt bucket objects"
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
