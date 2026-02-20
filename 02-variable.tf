variable "project" {
  default = "hsbc"
}

variable "vpc_cidr" {
  default = "172.16.0.0/16"
}

variable "vpc_subnets" {
  default = "1"
}

variable "type" {
  description = "Instance type"    
  default = "t2.micro"
}

variable "dbami" {
  description = "Red Hat Enterprise Linux version 10"
  default = "ami-0ad50334604831820"
}

variable "webami" {
  description = "Amazon Linux 2023 AMI"
  default = "ami-0f3caa1cf4417e51b"
}

variable "bastianami" {
  description = "Ubuntu Server 24.04 LTS"
  default = "ami-0b6c6ebed2801a5cb"
}
