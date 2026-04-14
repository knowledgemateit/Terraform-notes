provider "aws" {
  region     = "us-east-1"
}
module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 3.0"

  for_each = toset(["one", "two", "three"])

  name = "instance-${each.key}"

  ami                    = "ami-071226ecf16aa7d96"
  instance_type          = "t2.micro"
  key_name               = "tets22"
  monitoring             = true
  vpc_security_group_ids = ["sg-0c7d4230ac5a068f8"]
  subnet_id              = "subnet-0051dcb35a8f998ca"

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}
