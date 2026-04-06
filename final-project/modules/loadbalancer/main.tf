module "alb" {
  source = "terraform-aws-modules/alb/aws"

  enable_deletion_protection = false
  name    = var.alb-name
  vpc_id  = var.alb-vpc-id
  subnets = var.alb-public-subnets
  security_groups = var.alb-sgs
  create_security_group = false
  internal = var.internal_lb
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
      port             = var.target_port
      target_type      = "instance"
      target_id        =var.ec2-instance-id
    
    }
  }

  tags = {
    Environment = "Development"
    Project     = "Example"
  }
}


