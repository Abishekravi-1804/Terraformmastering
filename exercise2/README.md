# Terraform Day 2: Parameterized AWS S3 Bucket

## Overview

This project demonstrates using variables and outputs in Terraform to build flexible, reusable AWS S3 bucket infrastructure.

## Features

- **Parameterized AWS region, bucket name, environment, and owner:** Easily deploy in different contexts.
- **Unique S3 bucket naming with a random suffix.**
- **Bucket versioning** and **KMS encryption** for security and compliance.
- **Strict bucket policy** scoped to your AWS account and blocking all public access.
- **Resource tagging** for tracking environment and ownership.
- **Clear outputs** for bucket name, ARN, and policy ID.

## Usage

1. Edit `terraform.tfvars` to set your values (region, prefix, owner, environment, etc.).
2. Run the following in your project directory:

terraform init
terraform plan
terraform apply

3. After provisioning, view outputs for your bucket.
4. Clean up resources as needed:

terraform destroy


## Key Files

- `main.tf` — AWS provider, S3 bucket, versioning, encryption, policies.
- `variables.tf` — Input variables for all parameters.
- `outputs.tf` — Outputs for reference info.
- `terraform.tfvars` — Your deployment-specific variable values.

## Security

- S3 bucket access is account-restricted; public access is blocked.
- KMS encryption secures bucket objects at rest.

## Next Steps

- Reuse these patterns for other AWS resource types.
- Combine with networking or compute as you advance!

---

Happy Terraforming!

