# Terraform Day 5 – VPC Peering & Network ACLs

## 🚀 Project Overview

- Deploys two VPCs: **VPC1 (Management)** and **VPC2 (Production)**
- VPC Peering for secure cross-VPC communication
- Subnet-level security with **Network ACLs**
- EC2 instances: Bastion Host (VPC1), Web Servers (VPC2), Database Server (VPC1)
- SSH key pair generated automatically (private and public key output)

---

## 🏗️ Architecture

- **VPC1 (Management):**
  - Public & private subnets
  - Bastion host in public subnet
  - Database server in private subnet
- **VPC2 (Production):**
  - Public & private subnets
  - Web servers (Apache) in private subnet
  - [Optional] Application Load Balancer (ALB) in public subnet, Auto Scaling
- **VPC Peering** enables internal traffic between Management and Production.
- **Network ACLs** restrict/allow traffic at the subnet level.

---
## 📊 Project Structure

.
├── main.tf # Root Terraform configuration
├── variables.tf # Root input variables
├── outputs.tf # Root outputs
├── terraform.tfvars # Variable values; edit your IP & subnet CIDRs here

├── keypair/ # Generates SSH key pair
├── vpc1/ # VPC1 (Management), subnets, routes, security groups
├── vpc2/ # VPC2 (Production), subnets, routes, security groups
├── peering/ # VPC peering connection, routes
├── network-acls/ # Network ACL resources
└── instances/ # Bastion, web servers, database server EC2s
---

## ✏️ Prerequisites

- AWS account, `aws` CLI configured
- Terraform installed
- Update `terraform.tfvars` with your IP (allowed_ssh_cidr) and subnet preferences

---

## ⚡ Deployment Steps

1. **Initialize Terraform**

terraform init


2. **Review Plan**

terraform plan


3. **Apply**

terraform apply


---

## 🔑 Access Instructions

- Retrieve your SSH private key:

terraform output -raw private_key_pem > day6-private-key.pem
chmod 600 day6-private-key.pem

- From bastion, SSH into the web servers or database with their private IPs.

# 🧪 Validation

- Test SSH between bastion and all instances.
- Ping between VPCs (should succeed due to peering).
- Verify HTTP/web server is running: `curl http://localhost` on a web instance.
- Test database access from bastion and web server.
- Confirm blocked traffic matches your NACL/Security Group design.

---

## 🧹 Cleanup

Destroy all resources:
terraform destroy
