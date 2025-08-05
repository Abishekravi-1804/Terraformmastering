variable "bastion_ami" {
  type = string
}

variable "bastion_instance_type" {
  type = string
}

variable "bastion_subnet_id" {
  type = string
}

variable "app_ami" {
  type = string
}

variable "app_instance_type" {
  type = string
}

variable "private_subnet_id" {
  type = string
}

variable "bastion_sg_id" {
  type = string
}

variable "app_sg_id" {
  type = string
}

variable "key_name" {
  type = string
  default = "stagingkey"
}
