variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

variable "bucket_prefix" {
  description = "Prefix for S3 bucket name"
  type        = string
  default     = "my-terraform-demo"
}

variable "environment" {
  description = "Deployment environment (dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "owner" {
  description = " defining the owner of the bucket "
  type        = string
  default     = "Abishek"
}

variable "root_account_id" {
  description = " AWS Account ID"
  type        = string
  sensitive   = true
}
variable "kms_description"{
    description = "This key is used to encrypt bucket objects"
    type = string
    default     = "KMS key for S3 bucket encryption"
}



