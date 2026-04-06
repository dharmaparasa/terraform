module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"

  name = var.instance-name
  create_security_group = false
  instance_type = var.instance-type
  subnet_id     = var.subnet-id
  vpc_security_group_ids = var.sg_ids

  user_data = var.user_data
  user_data_replace_on_change = true

  tags = {
    Terraform   = "true"
    Environment = "dev"
    Name = var.name
  }
}



