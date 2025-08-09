variable "key_name" {
  description = "Name of existing AWS Key Pair for SSH"
  type        = string
}

variable "allowed_ssh_cidr" {
  description = "CIDR block allowed for SSH access"
  type        = string
  default     = "0.0.0.0/0"
}
