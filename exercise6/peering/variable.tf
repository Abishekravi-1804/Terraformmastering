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

variable "vpc2_vpc_cidr" {
  description = "VPC2 CIDR"
  type        = string
}

variable "vpc1_vpc_cidr" {
  description = "VPC1 CIDR"
  type        = string
}

variable "vpc2_private_route_table_id" {
  description = "VPC2 private route table ID"
  type        = string
}

variable "vpc1_route_table_ids" {
  description = "VPC1 route table IDs"
  type        = list(string)
}
