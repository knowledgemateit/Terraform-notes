# Provider configuration
provider "aws" {
region = "us-east-1"
}
# VPC
resource "aws_vpc" "example_vpc" {
cidr_block = "10.0.0.0/16"
}
# Internet Gateway
resource "aws_internet_gateway" "example_igw" {
vpc_id = aws_vpc.example_vpc.id
}
# Public Subnet
resource "aws_subnet" "public_subnet" {
vpc_id = aws_vpc.example_vpc.id
cidr_block = "10.0.1.0/24"
map_public_ip_on_launch = true
}
# Private Subnet
resource "aws_subnet" "private_subnet" {
vpc_id = aws_vpc.example_vpc.id
cidr_block = "10.0.2.0/24"
}
# Route Table for Public Subnet
resource "aws_route_table" "public_route_table" {
vpc_id = aws_vpc.example_vpc.id
}
resource "aws_route" "public_route" {
route_table_id = aws_route_table.public_route_table.id
destination_cidr_block = "0.0.0.0/0"
gateway_id = aws_internet_gateway.example_igw.id
}
# Associate Route Table with Public Subnet
resource "aws_route_table_association" "public_association" {
subnet_id = aws_subnet.public_subnet.id
route_table_id = aws_route_table.public_route_table.id
}
