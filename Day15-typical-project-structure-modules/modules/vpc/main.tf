resource "aws_vpc" "name" {
  cidr_block = var.vpc_cidr
  tags = {
    Name=var.vpc_name
  }
}