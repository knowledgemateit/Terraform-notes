terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.0"
    }
  }
}

provider "aws" {
  region     = "us-east-1"
  # access_key = "xxxxxxxxxxxxxxxxxxxx"
  # secret_key = "xxxxxxxxxxxxxxxxxx"
}
module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 2.19.0"

  name = "single-instance"

  ami                    = "ami-098e39bafa7e7303d"
  instance_type          = "t2.micro"
  key_name               = "terraform_Server"
  monitoring             = true
  
  tags = {
    Name = "terraform-instance"
    Terraform   = "true"
    Environment = "dev"
  }
}
