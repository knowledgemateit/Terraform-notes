###################################################################
# Creating Public Subnet1
###################################################################

resource "aws_subnet" "public1" {
    
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = cidrsubnet(var.vpc_cidr,var.vpc_subnets, 0)
  map_public_ip_on_launch = true
  availability_zone       = data.aws_availability_zones.az.names[0]
  tags = {
    Name = "${var.project}-public1"
    Project = var.project
  }
  lifecycle {
    create_before_destroy = false
  }
}




###################################################################
# Creating Private Subnet1
###################################################################

resource "aws_subnet" "private1" {
    
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = cidrsubnet(var.vpc_cidr,var.vpc_subnets,1)
  map_public_ip_on_launch = false
  availability_zone       = data.aws_availability_zones.az.names[1]
  tags = {
    Name = "${var.project}-private1"
    Project = var.project
  }
  lifecycle {
    create_before_destroy = false
  }
}

