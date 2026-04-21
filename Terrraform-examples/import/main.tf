#  terraform import aws_instance.console i-0a540f40b0b1f756e
provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "console" {
  ami = "ami-098e39bafa7e7303d"
  instance = "t3.micro"
}
