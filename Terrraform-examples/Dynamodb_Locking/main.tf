provider "aws" {
  region     = "us-east-1"
}

module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 2.19.0"

  name = "single-instance"

  ami                    = "ami-0eb38b817b93460ac"
  instance_type          = "t3.micro"
  key_name               = "test123"
  monitoring             = true
  subnet_id = "subnet-082574a5d56740791"
  
  tags = {
    Name = "terraform-instance"
    Terraform   = "true"
    Environment = "prod"
  }
}
terraform {
  backend "s3" {
    bucket         = "my-unique-avan-name123" # Replace with your S3 bucket name
    key            = "terraform.tfstate" # Key is the name of the state file in the bucket
    region         = "us-east-1" # Replace with your desired AWS region
    encrypt        = true
    dynamodb_table = "terraform-state-lock"
  }
}
