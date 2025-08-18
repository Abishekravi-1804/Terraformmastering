variable "environment" {
  description = "Environment name"
  type        = string
}

variable "vpc2_vpc_id" {
  description = "VPC2 ID"
  type        = string
}

variable "vpc1_vpc_id" {
  description = "VPC1 ID"
  type        = string
}

variable "vpc2_public_subnet_ids" {
  description = "VPC2 public subnet IDs"
  type        = list(string)
}

variable "vpc2_private_subnet_ids" {
  description = "VPC2 private subnet IDs"
  type        = list(string)
}

variable "vpc1_private_subnet_ids" {
  description = "VPC1 private subnet IDs"
  type        = list(string)
}

variable "vpc2_vpc_cidr" {
  description = "VPC2 CIDR"
  type        = string
}

variable "vpc1_vpc_cidr" {
  description = "VPC1 CIDR"
  type        = string
}

variable "vpc2_public_cidr" {
  description = "VPC2 public subnets CIDR range"
  type        = string
}

variable "vpc1_public_cidr" {
  description = "VPC1 public subnets CIDR range"
  type        = string
}
