#!/bin/bash
# complete-day7-cleanup.sh

set -e

echo "🗑️ Complete Day 7 Cleanup Starting..."
echo "====================================="

# Function to wait with dots
wait_with_dots() {
    local seconds=$1
    local message=$2
    echo -n "$message"
    for i in $(seq 1 $seconds); do
        echo -n "."
        sleep 1
    done
    echo " Done!"
}

# 1. Terminate EC2 instances
echo "1. Checking EC2 instances..."
INSTANCE_IDS=$(aws ec2 describe-instances --filters 'Name=tag:Day,Values=7' 'Name=instance-state-name,Values=running,stopped,pending' --query 'Reservations[*].Instances[*].InstanceId' --output text)

if [ -n "$INSTANCE_IDS" ] && [ "$INSTANCE_IDS" != "None" ]; then
    echo "   Terminating instances: $INSTANCE_IDS"
    aws ec2 terminate-instances --instance-ids $INSTANCE_IDS
    wait_with_dots 30 "   Waiting for termination"
else
    echo "   ✅ No Day 7 instances found"
fi

# 2. Delete S3 buckets
echo "2. Checking S3 buckets..."
aws s3 ls | grep terraform-state | awk '{print $3}' | while read bucket; do
    if [ -n "$bucket" ]; then
        echo "   Deleting bucket: $bucket"
        aws s3 rm s3://$bucket --recursive 2>/dev/null || true
        aws s3api delete-objects --bucket $bucket --delete "$(aws s3api list-object-versions --bucket $bucket --query '{Objects: [Versions,DeleteMarkers][].{Key: Key, VersionId: VersionId}}' --output json 2>/dev/null)" 2>/dev/null || true
        aws s3 rb s3://$bucket --force 2>/dev/null || true
        echo "   ✅ Bucket $bucket deleted"
    fi
done

# 3. Delete DynamoDB tables
echo "3. Checking DynamoDB tables..."
aws dynamodb list-tables --query 'TableNames' --output text | tr '\t' '\n' | grep -E 'terraform.*state|day7' | while read table; do
    if [ -n "$table" ]; then
        echo "   Deleting table: $table"
        aws dynamodb delete-table --table-name $table 2>/dev/null || true
        echo "   ✅ Table $table deleted"
    fi
done

# 4. Delete VPC and networking
echo "4. Checking VPC..."
VPC_ID=$(aws ec2 describe-vpcs --filters 'Name=tag:Day,Values=7' --query 'Vpcs[0].VpcId' --output text 2>/dev/null || echo "None")

if [ "$VPC_ID" != "None" ] && [ -n "$VPC_ID" ]; then
    echo "   Deleting VPC: $VPC_ID"
    
    # Delete NAT gateways
    aws ec2 describe-nat-gateways --filter "Name=vpc-id,Values=$VPC_ID" --query 'NatGateways[].NatGatewayId' --output text | xargs -r aws ec2 delete-nat-gateway --nat-gateway-id 2>/dev/null || true
    
    # Delete route table associations
    aws ec2 describe-route-tables --filters "Name=vpc-id,Values=$VPC_ID" --query 'RouteTables[?Associations[?Main==`false`]].Associations[?Main==`false`].RouteTableAssociationId' --output text | xargs -r aws ec2 disassociate-route-table --association-id 2>/dev/null || true
    
    # Delete route tables
    aws ec2 describe-route-tables --filters "Name=vpc-id,Values=$VPC_ID" --query 'RouteTables[?Associations[0].Main==`false`].RouteTableId' --output text | xargs -r aws ec2 delete-route-table --route-table-id 2>/dev/null || true
    
    # Delete internet gateway
    IGW_ID=$(aws ec2 describe-internet-gateways --filters "Name=attachment.vpc-id,Values=$VPC_ID" --query 'InternetGateways.InternetGatewayId' --output text 2>/dev/null || echo "None")
    if [ "$IGW_ID" != "None" ] && [ -n "$IGW_ID" ]; then
        aws ec2 detach-internet-gateway --internet-gateway-id $IGW_ID --vpc-id $VPC_ID 2>/dev/null || true
        aws ec2 delete-internet-gateway --internet-gateway-id $IGW_ID 2>/dev/null || true
    fi
    
    # Delete subnets
    aws ec2 describe-subnets --filters "Name=vpc-id,Values=$VPC_ID" --query 'Subnets[].SubnetId' --output text | xargs -r aws ec2 delete-subnet --subnet-id 2>/dev/null || true
    
    # Delete security groups
    aws ec2 describe-security-groups --filters "Name=vpc-id,Values=$VPC_ID" --query 'SecurityGroups[?GroupName!=`default`].GroupId' --output text | xargs -r aws ec2 delete-security-group --group-id 2>/dev/null || true
    
    # Delete VPC
    aws ec2 delete-vpc --vpc-id $VPC_ID 2>/dev/null || true
    echo "   ✅ VPC $VPC_ID deleted"
else
    echo "   ✅ No Day 7 VPC found"
fi

# 5. Delete IAM policies
echo "5. Checking IAM policies..."
aws iam list-policies --query 'Policies[?contains(PolicyName,`day7`) || contains(PolicyName,`terraform-state`)].Arn' --output text | while read policy_arn; do
    if [ -n "$policy_arn" ] && [ "$policy_arn" != "None" ]; then
        echo "   Deleting policy: $policy_arn"
        aws iam delete-policy --policy-arn $policy_arn 2>/dev/null || true
        echo "   ✅ Policy deleted"
    fi
done

# 6. Clean local files
echo "6. Cleaning local files..."
rm -f terraform.tfstate* .terraform.lock.hcl tfplan terraform.tfplan 2>/dev/null || true
rm -rf .terraform/ 2>/dev/null || true
echo "   ✅ Local files cleaned"

echo ""
echo "🎉 Complete Day 7 Cleanup Finished!"
echo "=================================="
echo ""
echo "Verification commands:"
echo "aws ec2 describe-instances --filters 'Name=tag:Day,Values=7'"
echo "aws ec2 describe-vpcs --filters 'Name=tag:Day,Values=7'"
echo "aws s3 ls | grep terraform"
echo "aws dynamodb list-tables | grep terraform"
