provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "logs" {
  bucket = "bharath-devops-test-2025"
}

# STEP 1: Turn off the "Block Public Access" settings
resource "aws_s3_bucket_public_access_block" "logs_access" {
  bucket = aws_s3_bucket.logs.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# STEP 2: Attach the policy
resource "aws_s3_bucket_policy" "allow_access" {
  bucket = aws_s3_bucket.logs.id

  # CRITICAL: This must depend on the ACCESS BLOCK, not just the bucket!
  depends_on = [aws_s3_bucket_public_access_block.logs_access]

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "PublicReadGetObject",
      "Effect": "Allow",
      "Principal": "*",
      "Action": "s3:GetObject",
      "Resource": "arn:aws:s3:::bharath-devops-test-2025/*"
    }
  ]
}
POLICY
}
