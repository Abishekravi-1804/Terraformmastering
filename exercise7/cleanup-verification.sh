#!/bin/bash
# cleanup-verification.sh

echo "🔍 Day 7 Cleanup Verification Report"
echo "==================================="

# S3 Buckets
echo "1. S3 Buckets:"
S3_RESULT=$(aws s3 ls | grep terraform-state || echo "✅ No terraform-state buckets found")
echo "$S3_RESULT"

# DynamoDB Tables  
echo -e "\n2. DynamoDB Tables:"
DYNAMO_RESULT=$(aws dynamodb list-tables | grep terraform-state || echo "✅ No terraform-state tables found")
echo "$DYNAMO_RESULT"

# EC2 Instances
echo -e "\n3. EC2 Instances (Day 7):"
EC2_RESULT=$(aws ec2 describe-instances --filters 'Name=tag:Day,Values=7' --query 'Reservations[*].Instances[*].[InstanceId,State.Name]' --output text || echo "✅ No Day 7 instances found")
[ -z "$EC2_RESULT" ] && echo "✅ No Day 7 instances found" || echo "$EC2_RESULT"

# VPCs
echo -e "\n4. VPCs (Day 7):"
VPC_RESULT=$(aws ec2 describe-vpcs --filters 'Name=tag:Day,Values=7' --query 'Vpcs[*].[VpcId]' --output text || echo "✅ No Day 7 VPCs found")
[ -z "$VPC_RESULT" ] && echo "✅ No Day 7 VPCs found" || echo "$VPC_RESULT"

# Local files
echo -e "\n5. Local State Files:"
if ls terraform.tfstate* 2>/dev/null; then
    echo "⚠️  Local state files still exist"
else
    echo "✅ No local state files found"
fi

echo -e "\n🎉 Cleanup verification completed!"
