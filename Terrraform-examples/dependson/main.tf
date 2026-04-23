provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "logs" {
  bucket = "bharath-devops-test-2025"
}

# 1. This resource UNLOCKS the bucket to allow public policies
resource "aws_s3_bucket_public_access_block" "logs_access" {
  bucket = aws_s3_bucket.logs.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# 2. This resource ATTACHES the actual policy
resource "aws_s3_bucket_policy" "allow_access" {
  bucket = aws_s3_bucket.logs.id

  # CRITICAL: Wait for the bucket to be UNLOCKED before applying the policy
  depends_on = [aws_s3_bucket_public_access_block.logs_access]

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid" : "PublicReadGetObject",
      "Effect": "Allow",
      "Principal": "*",
      "Action": "s3:GetObject",
      "Resource": "arn:aws:s3:::bharath-devops-test-2025/*"
    }
  ]
}
POLICY
}
