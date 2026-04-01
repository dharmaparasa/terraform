output "private-subnet-ids" {
  value = module.vpc.private_subnets
  description = "List of private subnet ids"
}
output "public-subnet-ids" {
  value = module.vpc.public_subnets
  description = "List of public subnet ids"
}

output "vpc-id" {
  value = module.vpc.vpc_id
}