# Terraform Modular VPC & EC2 Project

## Overview
This repository contains modular Terraform code for creating a multi-AZ VPC architecture with public and private subnets, NAT Gateway, bastion host, and private application EC2 instances.

## Structure
- `main.tf`, `variables.tf`, `outputs.tf` at root: Root module calling submodules.
- `vpc/` folder: Defines the VPC, subnets, route tables, NAT Gateway, internet gateway, and security groups.
- `ec2/` folder: Launches bastion and private app EC2 instances with necessary security group assignments.

## How to Use
1. Customize variables in `terraform.tfvars`.
2. Run:

terraform init
terraform plan
terraform apply

3. Use outputs for connecting to bastion and private instances.

## Notes
- Sensitive data and Terraform state files are excluded from version control.
- Only essential files (`main.tf`, `variables.tf`, `outputs.tf`) are tracked in this repo.
