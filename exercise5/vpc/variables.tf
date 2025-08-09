variable "environment" {
  description = "Environment name"
  type        = string
  default     = "staging"
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnets" {
  description = "Public subnet CIDR blocks"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnets" {
  description = "Private subnet CIDR blocks"
  type        = list(string)
  default     = ["10.0.101.0/24", "10.0.102.0/24"]
}

variable "availability_zones" {
  description = "Availability zones"
  type        = list(string)
  default     = ["ap-south-1a", "ap-south-1b"]
}

variable "allowed_ssh_cidr" {
  description = "CIDR block allowed for SSH access"
  type        = string
  default     = "0.0.0.0/0"
}

variable "alb_sg_name" {
  description = "Name for ALB security group"
  type        = string
  default     = "alb-sg"
}

variable "bastion_sg_name" {
  description = "Name for bastion security group"
  type        = string
  default     = "bastion-sg"
}

variable "app_sg_name" {
  description = "Name for app security group"
  type        = string
  default     = "app-sg"
}

variable "alb_ingress_ports" {
  description = "Ingress ports for ALB"
  type        = list(number)
  default     = [80, 443]
}

variable "ssh_port" {
  description = "SSH port"
  type        = number
  default     = 22
}

variable "http_port" {
  description = "HTTP port"
  type        = number
  default     = 80
}
