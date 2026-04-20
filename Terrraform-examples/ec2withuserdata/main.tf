# Provider configuration
provider "aws" {
region = "us-east-1"
}
# EC2 instance
resource "aws_instance" "web_server" {
ami = "ami-098e39bafa7e7303d"
instance_type = "t2.micro"
key_name = "terraform_Server"
user_data = <<-EOF
 #!/bin/bash
 sudo yum update -y
 sudo yum install -y httpd
 sudo systemctl start httpd
 sudo systemctl enable httpd
EOF
tags = {
 Name = "WebServer"
}
}
# Output the public IP
output "web_server_ip" {
value = aws_instance.web_server.public_ip
}
