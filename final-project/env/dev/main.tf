//creating VPC, subnets, nat routing tables, etc
module "vpc" {
  source = "../../modules/vpc"
  vpc-cidr = "10.0.0.0/16"
  vpc-name = "Karthikvpc"
}

//Sg for ec2
module "ec2-sg" { 
  source = "../../modules/securitygroup"
  ingress-rule-map = {
    22 = "0.0.0.0/0" 
    80 = "0.0.0.0/0" 
  }
  sg-vpc = module.vpc.vpc-id
  sg-name = "ec2-sg"
  name-tag = "SG1"
}

//sg for alb
module "alb-sg" { 
  source = "../../modules/securitygroup"
  ingress-rule-map = {
    80 = "0.0.0.0/0" 
  }
  sg-vpc = module.vpc.vpc-id
  sg-name = "alb-sg"
  name-tag = "SG2"
}

//creating ec2 with custom sg
module "ec2" {
  source = "../../modules/ec2"
  instance-name = "InterviewServer"
  instance-type = "t2.micro"
  subnet-id = module.vpc.private-subnet-ids[0]
  sg_ids = [module.ec2-sg.sg_id]
}

module "alb" {
  source = "../../modules/loadbalancer"
  alb-name = "KarthikALB"
  alb-public-subnets = module.vpc.public-subnet-ids
  alb-sgs = [ module.alb-sg.sg_id ]
  alb-vpc-id = module.vpc.vpc-id
  ec2-instance-id = module.ec2.instance_id
}

