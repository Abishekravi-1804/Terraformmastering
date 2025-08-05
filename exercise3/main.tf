# Provider
provider "aws" {
  region = var.region
}

# VPC 

resource "aws_vpc" "dev_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name        = "dev-vpc"
    Environment = var.environment
  }
}

# Internet Gateway

resource "aws_internet_gateway" "dev_igw" {
  vpc_id = aws_vpc.dev_vpc.id

  tags = {
    Name        = "dev-igw"
    Environment = var.environment
  }
}

# Route Table
resource "aws_route_table" "dev_route_table" {
  vpc_id = aws_vpc.dev_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.dev_igw.id
  }

  tags = {
    Name        = "dev-route-table"
    Environment = var.environment
  }
}

# Route Table Association

resource "aws_route_table_association" "dev_route_assoc" {
  subnet_id      = aws_subnet.dev_subnet.id
  route_table_id = aws_route_table.dev_route_table.id
}



# subnet

resource "aws_subnet" "dev_subnet" {
  vpc_id            = aws_vpc.dev_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = var.availability_zone
  tags = {
    Name        = "dev-subnet"
    Environment = var.environment
  }
}

# Security group

resource "aws_security_group" "dev_sg" {
  name        = "dev-sg"
  description = "Allow SSH and HTTP traffic"
  vpc_id      = aws_vpc.dev_vpc.id

  # SSH

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.my_ip]
  }

  # HTTP

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "dev"
    Environment = var.environment
  }
}

#  key pair
resource "aws_key_pair" "dev_key" {
  key_name   = "devkey"
  public_key = file(var.public_key_path)
}

# EC2 instance

resource "aws_instance" "dev_instance" {
  ami                    = var.ami
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.dev_subnet.id
  vpc_security_group_ids = [aws_security_group.dev_sg.id]
  key_name               = aws_key_pair.dev_key.key_name
  associate_public_ip_address = true  

  tags = {
    Name        = "dev-instance"
    Environment = var.environment
  }
}