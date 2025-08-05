module "vpc" {
  source          = "./vpc"
  vpc_cidr        = "10.0.0.0/16"
  public_subnets  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnets = ["10.0.101.0/24", "10.0.102.0/24"]
  availability_zones = ["ap-south-1a", "ap-south-1b"]
}

module "ec2" {
  source            = "./EC2"
  bastion_subnet_id = module.vpc.public_subnet_ids[0]
  private_subnet_id = module.vpc.private_subnet_ids[0]

  bastion_ami         = "ami-0f918f7e67a3323f0"  
  bastion_instance_type = "t2.micro"

  app_ami            = "ami-0f918f7e67a3323f0"
  app_instance_type  = "t2.micro"
  
  bastion_sg_id      = module.vpc.bastion_sg_id
  app_sg_id          = module.vpc.app_sg_id

  key_name           = var.key_name
}

