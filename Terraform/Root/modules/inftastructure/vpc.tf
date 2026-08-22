# VPC creation

resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support = true
  tags = {
    Name = var.vpc_name
  }
  }

# public subnets

resource "aws_subnet" "public1" {
  vpc_id = aws_vpc.vpc.id
  cidr_block = var.public_subnet_1_cidr
  availability_zone = var.az_1a
  map_public_ip_on_launch = true
  tags = {
    Name = "${var.vpc_name}-public-subnet-1"
  }
}

resource "aws_subnet" "public2" {
  vpc_id = aws_vpc.vpc.id
  cidr_block = var.public_subnet_2_cidr
  availability_zone = var.az_1b
  map_public_ip_on_launch = true
  tags = {
    Name = "${var.vpc_name}-public-subnet-2"
  }
}

# private subnets for frontend

resource "aws_subnet" "private1" {
  vpc_id = aws_vpc.vpc.id
  cidr_block = var.private_subnet_1_cidr
  availability_zone = var.az_1a
  tags = {
    Name = "${var.vpc_name}-private-web-subnet-1"
  }
}

resource "aws_subnet" "private2" {
  vpc_id = aws_vpc.vpc.id
  cidr_block = var.private_subnet_2_cidr
  availability_zone = var.az_1b
  tags = {
    Name = "${var.vpc_name}-private-web-subnet-2"
  }
}

# private subnets for backend

resource "aws_subnet" "private3" {
  vpc_id = aws_vpc.vpc.id
  cidr_block = var.private_subnet_3_cidr
  availability_zone = var.az_1a
  tags = {
    Name = "${var.vpc_name}-private-application-subnet-1"
  }
}

resource "aws_subnet" "private4" {
  vpc_id = aws_vpc.vpc.id
  cidr_block = var.private_subnet_4_cidr
  availability_zone = var.az_1b
  tags = {
    Name = "${var.vpc_name}-private-application-subnet-2"
  }
}

# private subnets for database

resource "aws_subnet" "private5" {
  vpc_id = aws_vpc.vpc.id
  cidr_block = var.private_subnet_5_cidr
  availability_zone = var.az_1a
  tags = {
    Name = "${var.vpc_name}-private-db-subnet-1"
  }
}

resource "aws_subnet" "private6" {
  vpc_id = aws_vpc.vpc.id
  cidr_block = var.private_subnet_6_cidr
  availability_zone = var.az_1b
  tags = {
    Name = "${var.vpc_name}-private-db-subnet-2"
  }
}

# inerrnet gateway

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.vpc_name}-igw"
  }
}

# Public Route Table
 resource "aws_route_table" "public_rt" {
   vpc_id = aws_vpc.vpc.id
   tags = {
    Name = "${var.vpc_name}-public-rt"
  }
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
 }

 resource "aws_route_table_association" "public" {
  for_each = {
    pub1 = aws_subnet.public1.id
    pub2 = aws_subnet.public2.id
  }

  subnet_id      = each.value
  route_table_id = aws_route_table.public_rt.id
}

# NAT Gateway Regional

resource "aws_nat_gateway" "nat" {
    vpc_id = aws_vpc.vpc.id
    tags = {
        Name = "${var.vpc_name}-nat"
    }
    availability_mode = "regional"
}

# Private Route Table

resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "${var.vpc_name}-private-rt"
  }
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }
}

resource "aws_route_table_association" "private" {
    for_each = {
      web-1      = aws_subnet.private1.id
      web-2      = aws_subnet.private2.id
      app-1      = aws_subnet.private3.id
      app-2      = aws_subnet.private4.id
      database-1 = aws_subnet.private5.id
      database-2 = aws_subnet.private6.id
    }
    subnet_id      = each.value
  route_table_id = aws_route_table.private_rt.id
}