vpc2_vpc_cidr = "10.0.0.0/16"
vpc1_vpc_cidr = "10.1.0.0/16"

vpc2_public_subnets  = ["10.0.1.0/24", "10.0.2.0/24"]
vpc2_private_subnets = ["10.0.101.0/24", "10.0.102.0/24"]

vpc1_public_subnets  = ["10.1.1.0/24", "10.1.2.0/24"]
vpc1_private_subnets = ["10.1.101.0/24", "10.1.102.0/24"]

availability_zones = ["ap-south-1a", "ap-south-1b"]
allowed_ssh_cidr   = "0.0.0.0/0"
ami                = "ami-0f918f7e67a3323f0"
instance_type      = "t2.micro"
instance_count     = 2
environment        = "day6"
