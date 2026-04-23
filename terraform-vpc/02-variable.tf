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
  default = "t3.micro"
}

variable "dbami" {
  description = "Red Hat Enterprise Linux version 10"
  default = "ami-056244ee7f6e2feb8"
}

variable "webami" {
  description = "Amazon Linux 2023 AMI"
  default = "ami-098e39bafa7e7303d"
}

variable "bastianami" {
  description = "Ubuntu Server 24.04 LTS"
  default = "ami-0ec10929233384c7f"
}
