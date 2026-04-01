module "alb" {
  source = "terraform-aws-modules/alb/aws"

  name    = var.alb-name
  vpc_id  = var.alb-vpc-id
  subnets = var.alb-public-subnets
  security_groups = var.alb-sgs

  listeners = {
    http = {
      port     = 80
      protocol = "HTTP"
      forward = {
        target_group_key = "instance-target"
      }
    }
  }

  target_groups = {
    instance-target = {
      protocol         = "HTTP"
      port             = 80
      target_type      = "instance"
      target_id        =var.ec2-instance-id
    
    }
  }

  tags = {
    Environment = "Development"
    Project     = "Example"
  }
}


