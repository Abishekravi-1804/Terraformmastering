module "vpc" {
  source             = "./vpc"
  vpc_cidr           = "10.0.0.0/16"
  public_subnets     = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnets    = ["10.0.101.0/24", "10.0.102.0/24"]
  availability_zones = ["ap-south-1a", "ap-south-1b"]
  environment        = "staging"
  allowed_ssh_cidr   = var.allowed_ssh_cidr
}

module "ec2" {
  source                = "./EC2"
  bastion_subnet_id     = module.vpc.public_subnet_ids[0]
  bastion_ami           = "ami-0f918f7e67a3323f0"
  bastion_instance_type = "t2.micro"
  bastion_sg_id         = module.vpc.bastion_sg_id
  environment           = "staging"
}

module "autoscaling" {
  source             = "./autoscaling"
  environment        = "staging"
  vpc_id             = module.vpc.vpc_id
  public_subnet_ids  = module.vpc.public_subnet_ids
  private_subnet_ids = module.vpc.private_subnet_ids
  app_sg_id          = module.vpc.app_sg_id
  alb_sg_id          = module.vpc.alb_sg_id
  app_ami            = "ami-0f918f7e67a3323f0"
  app_instance_type  = "t2.micro"
  key_name           = module.ec2.key_pair_name
  min_size           = 1
  max_size           = 3
  desired_capacity   = 2
}
