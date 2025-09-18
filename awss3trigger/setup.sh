#!/bin/bash

echo "🚀 Starting setup for S3 + Lambda Thumbnail Generator..."

# ========================
# 1. Create S3 Buckets
# ========================
echo "📦 Creating source bucket..."
aws s3api create-bucket \
  --bucket my-s3-demo-source-bucket1 \
  --region ap-south-1 \
  --create-bucket-configuration LocationConstraint=ap-south-1

echo "📦 Creating destination bucket..."
aws s3api create-bucket \
  --bucket my-s3-demo-source-bucket1-resized \
  --region ap-south-1 \
  --create-bucket-configuration LocationConstraint=ap-south-1

# ========================
# 2. Upload test image (optional)
# ========================
if [ -f "./testing.jpg" ]; then
  echo "📤 Uploading test image to source bucket..."
  aws s3api put-object \
    --bucket my-s3-demo-source-bucket1 \
    --key testing.jpg \
    --body ./testing.jpg
else
  echo "⚠️  ./testing.jpg not found — skipping upload"
fi

# ========================
# 3. Create IAM Policy & Role
# ========================
echo "🔐 Creating IAM policy: LambdaS3Policy"
aws iam create-policy \
  --policy-name LambdaS3Policy \
  --policy-document file://policy.json

echo "🔐 Creating IAM role: LambdaS3Role"
aws iam create-role \
  --role-name LambdaS3Role \
  --assume-role-policy-document file://trust-policy.json

echo "⏳ Waiting 5 seconds for IAM role to propagate..."
sleep 5

echo "📎 Attaching policy to role..."
aws iam attach-role-policy \
  --role-name LambdaS3Role \
  --policy-arn arn:aws:iam::<123456789012>:policy/LambdaS3Policy

# ========================
# 4. Build Lambda Package
# ========================
echo "🏗️  Building Lambda deployment package..."

# Create package dir
mkdir -p package

# Install dependencies (Pillow + boto3 for Lambda)
pip install \
  --platform manylinux2014_x86_64 \
  --target=./package \
  --implementation cp \
  --python-version 3.12 \
  --only-binary=:all: \
  --upgrade \
  pillow boto3

# Create ZIP (flatten package contents)
echo "🗜️  Creating lambda_function.zip..."
powershell -Command "Get-ChildItem -Path lambda_function.py, .\package\* | Compress-Archive -DestinationPath lambda_function.zip -Force"

# ========================
# 5. Create Lambda Function
# ========================
echo "⚙️  Creating Lambda function: CreateThumbnail"
aws lambda create-function \
  --function-name CreateThumbnail \
  --zip-file fileb://lambda_function.zip \
  --handler lambda_function.lambda_handler \
  --runtime python3.12 \
  --timeout 10 \
  --memory-size 1024 \
  --role arn:aws:iam::<123456789012>:role/LambdaS3Role \
  --region ap-south-1

# ========================
# 6. Add S3 Permission to Invoke Lambda
# ========================
echo "🔑 Adding S3 permission to invoke Lambda..."
aws lambda add-permission \
  --function-name CreateThumbnail \
  --principal s3.amazonaws.com \
  --statement-id s3invoke \
  --action "lambda:InvokeFunction" \
  --source-arn arn:aws:s3:::my-s3-demo-source-bucket1 \
  --source-account <123456789012>

# ========================
# 7. Configure S3 Event Trigger
# ========================
echo "🔔 Configuring S3 event trigger..."
aws s3api put-bucket-notification-configuration \
  --bucket my-s3-demo-source-bucket1 \
  --notification-configuration file://notification.json

# ========================
# 8. Test Lambda with Dummy Event
# ========================
echo "🧪 Testing Lambda with dummy event..."
aws lambda invoke \
  --function-name CreateThumbnail \
  --invocation-type RequestResponse \
  --cli-binary-format raw-in-base64-out \
  --payload file://dummyS3Event.json \
  outputfile.txt

echo "📄 Test result (outputfile.txt):"
cat outputfile.txt

# ========================
# 9. Verify Thumbnail in Destination Bucket
# ========================
echo "🔍 Checking destination bucket for thumbnails..."
aws s3 ls s3://my-s3-demo-source-bucket1-resized/

echo "✅ Setup complete! Your S3 → Lambda → Thumbnail pipeline is ready."
echo "👉 Try uploading an image: aws s3 cp ./testing.jpg s3://my-s3-demo-source-bucket1/test-trigger.jpg"