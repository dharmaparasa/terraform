module "dev_ec2" {
  source = "../../modules/ec2"
  ami_id = var.dev_ami_id
  instance_type = var.dev_instance_type
}
module "dev_vpc" {
  source = "../../modules/vpc"
  vpc_cidr = var.vpc_cidr
  vpc_name = var.vpc_name
}
