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
}
module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 3.6.0"

  for_each = toset(["one", "two", "three"])

  name = "instance-${each.key}"

  ami                    = "ami-098e39bafa7e7303d"
  instance_type          = "t3.micro"
  key_name               = "terraform_Server"
  monitoring             = true
  vpc_security_group_ids = ["sg-01175d2568a7f698b"]
  subnet_id              = "subnet-082574a5d56740791"

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}
