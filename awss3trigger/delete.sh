#!/bin/bash

echo "🗑️  Starting cleanup..."

# 1. Delete Lambda function
echo "➡️  Deleting Lambda function: CreateThumbnail"
aws lambda delete-function --function-name CreateThumbnail

# 2. Empty source bucket
echo "➡️  Emptying source bucket: my-s3-demo-source-bucket1"
aws s3 rm s3://my-s3-demo-source-bucket1 --recursive

# 3. Empty destination bucket
echo "➡️  Emptying destination bucket: my-s3-demo-source-bucket1-resized"
aws s3 rm s3://my-s3-demo-source-bucket1-resized --recursive

# 4. Delete source bucket
echo "➡️  Deleting source bucket: my-s3-demo-source-bucket1"
aws s3api delete-bucket --bucket my-s3-demo-source-bucket1

# 5. Delete destination bucket
echo "➡️  Deleting destination bucket: my-s3-demo-source-bucket1-resized"
aws s3api delete-bucket --bucket my-s3-demo-source-bucket1-resized

# 6. Detach policy from role
echo "➡️  Detaching policy from role: LambdaS3Role"
aws iam detach-role-policy \
  --role-name LambdaS3Role \
  --policy-arn arn:aws:iam::<123456789012>:policy/LambdaS3Policy

# 7. Delete IAM policy
echo "➡️  Deleting policy: LambdaS3Policy"
aws iam delete-policy \
  --policy-arn arn:aws:iam::<123456789012>:policy/LambdaS3Policy

# 8. Delete IAM role
echo "➡️  Deleting role: LambdaS3Role"
aws iam delete-role --role-name LambdaS3Role

echo "✅ Cleanup complete!"