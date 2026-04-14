provider "aws" {
  region = "us-east-1"  # Specify your desired AWS region
}

resource "aws_s3_bucket" "my_bucket" {
  bucket = "my-unique-avan-name"  # Specify a globally unique bucket name

  acl    = "private"  # Access Control List for the bucket, can be adjusted based on your needs

  tags = {
    Name        = "my-unique-avan-name"
    Environment = "Production"
  }
}
