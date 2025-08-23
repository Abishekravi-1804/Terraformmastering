📖 Day 7: Terraform State Management
Terraform project demonstrating remote state management with AWS S3 backend and DynamoDB state locking.

🎯 What This Does
Creates AWS infrastructure (VPC, EC2 instances, security groups)

Sets up S3 bucket for remote state storage with encryption

Configures DynamoDB table for state locking

Deploys web servers for testing

📁 Project Structure
text
exercise7/
├── main.tf                    # Main Terraform configuration
├── variables.tf               # Input variables
├── outputs.tf                 # Output values
├── versions.tf                # Provider versions
├── locals.tf                  # Local values
├── userdata.sh               # EC2 bootstrap script
├── terraform.tfvars          # Your variables
├── Examples/
│   └── terraform.tfvars      # Example variables
└── complete-day7-cleanup.sh  # Cleanup script
🚀 Quick Start
1. Setup Variables
bash
# Copy example variables
cp Examples/terraform.tfvars terraform.tfvars

# Edit for your environment
nano terraform.tfvars
2. Deploy Infrastructure
bash
terraform init
terraform plan
terraform apply
3. Migrate to Remote State
bash
# Get backend config from output
terraform output backend_config

# Edit main.tf - uncomment backend block and update values
# Then migrate
terraform init -migrate-state
4. Test
bash
# Check web servers
terraform output ec2_public_ips
curl http://[YOUR_IP]

# View state
terraform state list
🔧 Key Commands
bash
# State operations
terraform state list
terraform state show aws_s3_bucket.terraform_state
terraform state pull > backup.tfstate

# Test state locking (run in 2 terminals)
terraform plan -lock-timeout=60s
terraform plan -lock-timeout=5s  # Should timeout

# Cleanup
terraform destroy
# OR
./complete-day7-cleanup.sh
🌍 Environment Variables
Edit terraform.tfvars:

text
aws_region = "ap-south-1"
project_name = "day7-state-mgmt"
environment = "dev"
instance_count = 2
instance_type = "t2.micro"
✅ Verification
After setup, you should have:

S3 bucket storing encrypted state

DynamoDB table for locking

2 web servers responding on port 80

Remote state working with terraform plan

🧹 Cleanup
bash
# Complete cleanup
terraform destroy

# Or use script
./complete-day7-cleanup.sh

# Verify cleanup
aws s3 ls | grep terraform-state  # Should be empty
🎓 Learning Goals
✅ Remote state vs local state

✅ S3 backend configuration

✅ State locking with DynamoDB

✅ Team collaboration workflows

✅ State backup and recovery

🔍 Troubleshooting
Web servers not responding?

bash
# Check security groups
aws ec2 describe-security-groups --group-ids $(terraform output -raw security_group_id)

# Recreate instances
terraform taint aws_instance.test_instances[0]
terraform apply
State lock issues?

bash
terraform force-unlock <lock-id>
Permission errors?

bash
aws sts get-caller-identity
📚 Prerequisites: Terraform ≥1.0, AWS CLI, AWS account with appropriate permissions

⏱️ Time: ~30 minutes | 💰 Cost: AWS free tier eligible

Happy learning! 🚀