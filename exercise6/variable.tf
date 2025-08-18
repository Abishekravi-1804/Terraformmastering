variable "vpc2_vpc_cidr" {
  description = "CIDR block for VPC2 (Production)"
  type        = string
}

variable "vpc1_vpc_cidr" {
  description = "CIDR block for VPC1 (Management)"
  type        = string
}

variable "vpc2_public_subnets" {
  description = "VPC2 public subnet CIDR blocks"
  type        = list(string)
}

variable "vpc2_private_subnets" {
  description = "VPC2 private subnet CIDR blocks"
  type        = list(string)
}

variable "vpc1_public_subnets" {
  description = "VPC1 public subnet CIDR blocks"
  type        = list(string)
}

variable "vpc1_private_subnets" {
  description = "VPC1 private subnet CIDR blocks"
  type        = list(string)
}

variable "availability_zones" {
  description = "Availability zones"
  type        = list(string)
}

variable "allowed_ssh_cidr" {
  description = "CIDR block allowed for SSH"
  type        = string
}

variable "ami" {
  description = "AMI ID"
  type        = string
}

variable "instance_type" {
  description = "Instance type"
  type        = string
}

variable "instance_count" {
  description = "Number of instances"
  type        = number
}

variable "environment" {
  description = "Environment name"
  type        = string
}
