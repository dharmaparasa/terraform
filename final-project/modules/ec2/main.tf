module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"

  name = var.instance-name
  create_security_group = false
  instance_type = var.instance-type
#   key_name      = "user1"
#   monitoring    = true
  subnet_id     = var.subnet-id
  vpc_security_group_ids = var.sg_ids

  tags = {
    Terraform   = "true"
    Environment = "dev"

    Name = "Dharma"
  }
}


