output "bucket_name" {
  description = "The name of the S3 bucket"
  value       = aws_s3_bucket.my_first_bucket.bucket
}

output "bucket_arn" {
  description = "The ARN of the S3 bucket"
  value       = aws_s3_bucket.my_first_bucket.arn
}

output "bucket_policy_id" {
  description = "ID of the attached bucket policy"
  value       = aws_s3_bucket_policy.private_policy.id
}
