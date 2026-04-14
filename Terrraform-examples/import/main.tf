#  terraform import aws_instance.console i-0a540f40b0b1f756e
provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "console" {
  ami = "ami-0866a3c8686eaeeba"
  instance = "t2.micro"
}
