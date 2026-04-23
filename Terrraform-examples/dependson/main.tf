# Provider configuration
provider "aws" {
region = "us-east-1"
}

resource "aws_s3_bucket" "logs" {
  bucket = "bharath-devops-test-2025"
}

resource "aws_s3_bucket_policy" "allow_access" {
  bucket = aws_s3_bucket.logs.id
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false

  # THE EASY EXAMPLE:
  # "Wait until the bucket is 100% finished before trying to attach this policy"
  depends_on = [aws_s3_bucket.logs]

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid" : "PublicReadGetObject"
      "Effect": "Allow",
      "Principal": "*",
      "Action": "s3:GetObject",
      "Resource": "arn:aws:s3:::bharath-devops-test-2025/*"
    }
  ]
}
POLICY
}
