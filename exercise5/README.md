# 📚 **Day 4 - Auto Scaling Group with Application Load Balancer**

## 🎯 **Project Overview**

This Day 5 project implements a comprehensive AWS infrastructure using Terraform that includes:
- **VPC** with public/private subnets across multiple AZs
- **Bastion Host** for secure SSH access to private instances
- **Auto Scaling Group (ASG)** for scalable web application instances
- **Application Load Balancer (ALB)** for distributing traffic
- **Security Groups** with proper access controls
- **NAT Gateway** for outbound internet access from private subnets

## 🏗️ **Architecture**

Internet Gateway ----Public Subnets (2 AZs)----ALB + Bastion Host----Private Subnets (2 AZs)----Auto Scaling Group (2-3 instances)----NAT Gateway (outbound only)

