# Provider configuration
provider "aws" {
region = "us-east-1"
}
# EC2 instance
resource "aws_instance" "web_server" {
ami = "ami-071226ecf16aa7d96"
instance_type = "t2.micro"
key_name = "tets22"
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
