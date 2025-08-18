resource "aws_vpc" "vpc2" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name        = "${var.environment}-vpc2-production"
    Environment = var.environment
    Purpose     = "Production"
  }
}

resource "aws_internet_gateway" "vpc2_igw" {
  vpc_id = aws_vpc.vpc2.id

  tags = {
    Name = "${var.environment}-vpc2-igw"
  }
}

resource "aws_subnet" "vpc2_public" {
  count                   = length(var.public_subnets)
  vpc_id                  = aws_vpc.vpc2.id
  cidr_block              = var.public_subnets[count.index]
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.environment}-vpc2-public-${count.index + 1}"
  }
}

resource "aws_subnet" "vpc2_private" {
  count             = length(var.private_subnets)
  vpc_id            = aws_vpc.vpc2.id
  cidr_block        = var.private_subnets[count.index]
  availability_zone = var.availability_zones[count.index]

  tags = {
    Name = "${var.environment}-vpc2-private-${count.index + 1}"
  }
}

resource "aws_route_table" "vpc2_public" {
  vpc_id = aws_vpc.vpc2.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.vpc2_igw.id
  }

  tags = {
    Name = "${var.environment}-vpc2-public-rt"
  }
}

resource "aws_route_table_association" "vpc2_public" {
  count          = length(aws_subnet.vpc2_public)
  subnet_id      = aws_subnet.vpc2_public[count.index].id
  route_table_id = aws_route_table.vpc2_public.id
}

resource "aws_route_table" "vpc2_private" {
  vpc_id = aws_vpc.vpc2.id

  tags = {
    Name = "${var.environment}-vpc2-private-rt"
  }
}

resource "aws_route_table_association" "vpc2_private" {
  count          = length(aws_subnet.vpc2_private)
  subnet_id      = aws_subnet.vpc2_private[count.index].id
  route_table_id = aws_route_table.vpc2_private.id
}

resource "aws_security_group" "vpc2_web" {
  name        = "${var.environment}-vpc2-web-sg"
  description = "Security group for VPC2 web servers"
  vpc_id      = aws_vpc.vpc2.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.vpc1_vpc_cidr]  
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.environment}-vpc2-web-sg"
  }
}
