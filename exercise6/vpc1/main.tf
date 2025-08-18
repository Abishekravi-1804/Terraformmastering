resource "aws_vpc" "vpc1" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name        = "${var.environment}-vpc1-management"
    Environment = var.environment
    Purpose     = "Management"
  }
}

resource "aws_internet_gateway" "vpc1_igw" {
  vpc_id = aws_vpc.vpc1.id

  tags = {
    Name = "${var.environment}-vpc1-igw"
  }
}

resource "aws_subnet" "vpc1_public" {
  count                   = length(var.public_subnets)
  vpc_id                  = aws_vpc.vpc1.id
  cidr_block              = var.public_subnets[count.index]
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.environment}-vpc1-public-${count.index + 1}"
  }
}

resource "aws_subnet" "vpc1_private" {
  count             = length(var.private_subnets)
  vpc_id            = aws_vpc.vpc1.id
  cidr_block        = var.private_subnets[count.index]
  availability_zone = var.availability_zones[count.index]

  tags = {
    Name = "${var.environment}-vpc1-private-${count.index + 1}"
  }
}

resource "aws_route_table" "vpc1_public" {
  vpc_id = aws_vpc.vpc1.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.vpc1_igw.id
  }

  tags = {
    Name = "${var.environment}-vpc1-public-rt"
  }
}

resource "aws_route_table_association" "vpc1_public" {
  count          = length(aws_subnet.vpc1_public)
  subnet_id      = aws_subnet.vpc1_public[count.index].id
  route_table_id = aws_route_table.vpc1_public.id
}

resource "aws_route_table" "vpc1_private" {
  vpc_id = aws_vpc.vpc1.id

  tags = {
    Name = "${var.environment}-vpc1-private-rt"
  }
}

resource "aws_route_table_association" "vpc1_private" {
  count          = length(aws_subnet.vpc1_private)
  subnet_id      = aws_subnet.vpc1_private[count.index].id
  route_table_id = aws_route_table.vpc1_private.id
}

resource "aws_security_group" "vpc1_bastion" {
  name        = "${var.environment}-vpc1-bastion-sg"
  description = "Security group for VPC1 bastion host"
  vpc_id      = aws_vpc.vpc1.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.allowed_ssh_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.environment}-vpc1-bastion-sg"
  }
}

resource "aws_security_group" "vpc1_database" {
  name        = "${var.environment}-vpc1-database-sg"
  description = "Security group for VPC1 database server"
  vpc_id      = aws_vpc.vpc1.id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = [var.vpc2_vpc_cidr]  
  }

  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.vpc1_bastion.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.environment}-vpc1-database-sg"
  }
}
