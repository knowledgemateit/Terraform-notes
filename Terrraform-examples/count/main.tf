# Provider configuration
provider "aws" {
region = "us-east-1"
}

resource "aws_instance" "web_cluster" {
  count         = 3  # Creates 3 instances
  ami           = "ami-098e39bafa7e7303d"
  instance_type = "t3.micro"
  subnet_id     = "subnet-082574a5d56740791"
  key_name               = "terraform_Server"
  tags = {
    # count.index will label them: Web-0, Web-1, Web-2
    Name = "Web-${count.index}" 
  }
}
