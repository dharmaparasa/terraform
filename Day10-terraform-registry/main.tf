module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"

  name = "dharma-instance"

  instance_type = "t3.micro"
#   key_name      = "user1"
  monitoring    = true
  //create subnet and give the subnet id
  subnet_id     = "subnet-eddcdzz4"

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}