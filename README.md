# Terraformmastering
# Terraform Day 1: AWS S3 Bucket Automation

## Overview

This Terraform configuration demonstrates the basics of provisioning and managing AWS S3 buckets as part of a Day 1 learning challenge in mastering Infrastructure as Code (IaC) with Terraform.

## What You Will Learn

- Setting up the AWS provider for Terraform with a specified region (`ap-south-1` in this case).  
- Creating an AWS S3 Bucket with a unique name using the `random_string` resource for name suffixing.  
- Enabling bucket versioning to protect against accidental overwrites and deletions.  
- Applying resource tags (Name, Environment, Owner) to organize and manage AWS resources effectively.  
- Securing the bucket by blocking all public access policies to enforce strict privacy.  
- Attaching a bucket policy scoped to your AWS account to limit access.  
- Enabling server-side encryption with AWS KMS for enhanced data security at rest.  
- Using Terraform outputs to easily retrieve important bucket details such as name, ARN, and policy ID after deployment.

## Prerequisites

- Terraform installed (version 1.0+ recommended)  
- AWS CLI configured with appropriate credentials (`aws configure`)  
- AWS account with permissions to create S3, KMS keys, and IAM policies.

## How to Use

1. Initialize Terraform:  

terraform init


2. Preview the infrastructure plan:  

terraform plan


3. Apply the changes (create the S3 bucket and related resources):  


terraform apply


4. After usage, destroy resources to avoid charges:  

terraform destroy


## Included Files

- **main.tf**: Terraform configuration defining the AWS provider, S3 bucket, random suffix, tagging, versioning, bucket policy, public access block, KMS key, and encryption.  
- **outputs.tf**: Outputs showing bucket name, ARN, and bucket policy ID for easy reference.

## Security Best Practices Implemented

- Public access to the bucket is fully blocked using `aws_s3_bucket_public_access_block`.  
- Bucket policy restricts access strictly to the AWS account root user.  
- Server-side encryption is enabled using a customer-managed KMS key for protecting data at rest.

## Notes

- Bucket names must be globally unique; the `random_string` suffix helps ensure this.  
- Be cautious when destroying and recreating the bucket as data may be lost if not backed up.  
- Modify tags and policies as per your organizational standards and compliance requirements.

## Next Steps

This Day 1 exercise forms the foundation of mastering Terraform with AWS. Up next: learn about EC2 provisioning, networking, and more advanced resource management.

---

Happy Terraforming!





