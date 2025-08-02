
variable "region" {
  type        = string
  default     = "ap-south-1"
  description = "AWS region"
}

variable "environment" {
  type        = string
  default     = "development"
  description = "Environment name"
}

variable "availability_zone" {
  type        = string
  default     = "ap-south-1a"
  description = "Availability zone"
}

variable "my_ip" {
  description = "IP addr "
  sensitive   = true
  type        = string
}


variable "public_key_path" {
  description = "Path to SSH public key file"
  type        = string
  sensitive   = true
}



variable "ami" {
  type        = string
  default     = "ami-0f918f7e67a3323f0"
  description = "AMI ID"
}

variable "instance_type" {
  type        = string
  default     = "t2.micro"
  description = "Instance type"
}