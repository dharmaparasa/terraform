
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = var.vpc-name
  cidr = var.vpc-cidr
  azs             = var.azs
  private_subnets = var.private-subnet-cidr
  public_subnets  = var.public-subnet-cidr

   enable_nat_gateway = true
   single_nat_gateway = true
#   enable_vpn_gateway = true

  tags = {
    Terraform = "true"
  }
}




