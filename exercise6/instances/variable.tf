variable "environment" {
  description = "Environment name"
  type        = string
}

variable "vpc2_private_subnet_ids" {
  description = "VPC2 private subnet IDs"
  type        = list(string)
}

variable "vpc1_public_subnet_id" {
  description = "VPC1 public subnet ID"
  type        = string
}

variable "vpc1_private_subnet_ids" {
  description = "VPC1 private subnet IDs"
  type        = list(string)
}

variable "vpc2_web_sg_id" {
  description = "VPC2 web security group ID"
  type        = string
}

variable "vpc1_bastion_sg_id" {
  description = "VPC1 bastion security group ID"
  type        = string
}

variable "vpc1_database_sg_id" {
  description = "VPC1 database security group ID"
  type        = string
}

variable "key_name" {
  description = "EC2 Key Pair name"
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
  description = "Number of web instances"
  type        = number
}
