variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "public_subnets" {
  type    = list(string)
  default = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnets" {
  type    = list(string)
  default = ["10.0.101.0/24", "10.0.102.0/24"]
}

variable "availability_zones" {
  type    = list(string)
  default = ["ap-south-1a", "ap-south-1b"]
}

variable "environment" {
  type    = string
  default = "staging"
  description = "environment "
}

variable "allowed_ssh_cidr" {
  type    = string
  default = "49.47.217.85/32" 
  description = "CIDR block allowed for SSH ingress"
}
