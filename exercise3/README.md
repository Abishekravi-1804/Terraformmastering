# Terraform Day 3: Custom VPC and Secure EC2 Instance

## Overview

This project provisions a custom AWS VPC and securely launches an EC2 instance using Terraform.

## Features

- **VPC custom network** with dedicated subnet, Internet Gateway, and proper routing.
- **Security group** allowing SSH access only from your IP and HTTP for future web server access.
- **Automatic SSH key generation** using Terraform (no manual key handling needed).
- **EC2 instance** deployed with your generated key and secure settings.
- **Flexible variables** for region, instance type, AMI, and more.
- **Outputs** for EC2 public IP, security group ID, private key, and SSH command.

## Usage

1. Set your variables in `terraform.tfvars`, including `my_ip` (your public IP in CIDR format) and optionally customize other values.
2. Run:

terraform init
terraform validate
terraform plan
terraform apply

3. Save the SSH private key output (from Terraform) as a file (e.g., `private_key.pem`), run `chmod 400 private_key.pem`.
4. Use the provided SSH command output to connect to your EC2 instance:

ssh -i private_key.pem ec2-user@<instance_public_ip>

5. When finished, destroy resources:
terraform destroy


## Key Files

- `main.tf` — Provider, VPC, Internet Gateway, subnet, route table, security group, key, and EC2 instance.
- `variables.tf` — All configurable input variables.
- `outputs.tf` — Instance details and keys for secure access.
- `terraform.tfvars` — Your environment settings.

## Security

- Only your IP can access the EC2 instance over SSH.
- All credentials are handled securely and generated fresh by Terraform.
- Proper AWS tagging for all resources.

## Next Steps

- Add user data scripts to bootstrap the EC2 instance.
- Experiment with multiple subnets and private networks.
- Use modules for even more reusability.

---

Automate responsibly and keep learning!


