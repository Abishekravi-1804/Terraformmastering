terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2.0"
    }
  }
}

provider "aws" {
  region = "ap-south-1"
}

module "keypair" {
  source = "./keypair"

  environment = var.environment
}

module "vpc2" {
  source = "./vpc2"

  environment        = var.environment
  vpc_cidr           = var.vpc2_vpc_cidr
  public_subnets     = var.vpc2_public_subnets
  private_subnets    = var.vpc2_private_subnets
  availability_zones = var.availability_zones
  vpc1_vpc_cidr      = var.vpc1_vpc_cidr
}

module "vpc1" {
  source = "./vpc1"

  environment        = var.environment
  vpc_cidr           = var.vpc1_vpc_cidr
  public_subnets     = var.vpc1_public_subnets
  private_subnets    = var.vpc1_private_subnets
  availability_zones = var.availability_zones
  allowed_ssh_cidr   = var.allowed_ssh_cidr
  vpc2_vpc_cidr      = var.vpc2_vpc_cidr
}

module "peering" {
  source = "./peering"

  environment                 = var.environment
  vpc2_vpc_id                 = module.vpc2.vpc_id
  vpc1_vpc_id                 = module.vpc1.vpc_id
  vpc2_vpc_cidr               = var.vpc2_vpc_cidr
  vpc1_vpc_cidr               = var.vpc1_vpc_cidr
  vpc2_private_route_table_id = module.vpc2.private_route_table_id
  vpc1_route_table_ids        = module.vpc1.route_table_ids
}

module "network_acls" {
  source = "./network-acls"

  environment             = var.environment
  vpc2_vpc_id             = module.vpc2.vpc_id
  vpc1_vpc_id             = module.vpc1.vpc_id
  vpc2_public_subnet_ids  = module.vpc2.public_subnet_ids
  vpc2_private_subnet_ids = module.vpc2.private_subnet_ids
  vpc1_private_subnet_ids = module.vpc1.private_subnet_ids
  vpc2_vpc_cidr           = var.vpc2_vpc_cidr
  vpc1_vpc_cidr           = var.vpc1_vpc_cidr
  vpc2_public_cidr        = "10.0.0.0/20"
  vpc1_public_cidr        = "10.1.0.0/20"
}

module "instances" {
  source = "./instances"

  depends_on = [module.peering, module.network_acls, module.keypair]

  environment             = var.environment
  vpc2_private_subnet_ids = module.vpc2.private_subnet_ids
  vpc1_public_subnet_id   = module.vpc1.public_subnet_ids[0]
  vpc1_private_subnet_ids = module.vpc1.private_subnet_ids
  vpc2_web_sg_id          = module.vpc2.web_security_group_id
  vpc1_bastion_sg_id      = module.vpc1.bastion_security_group_id
  vpc1_database_sg_id     = module.vpc1.database_security_group_id
  key_name                = module.keypair.key_name
  ami                     = var.ami
  instance_type           = var.instance_type
  instance_count          = var.instance_count
}
