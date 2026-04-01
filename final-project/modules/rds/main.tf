module "db" {
  source = "terraform-aws-modules/rds/aws"

  identifier = "demodb"
  engine            = "mysql"
  engine_version    = "8.0"
  instance_class    = var.db-instance-class
  allocated_storage = 5
  major_engine_version = "8.0"
  family = "mysql8.0"
  db_name  = "demodb"
  username = "user"
  port     = "3306"

  iam_database_authentication_enabled = true
  vpc_security_group_ids = var.db-sgs
  tags = {
    Owner       = "user"
    Environment = "dev"
  }
  # DB subnet group
  create_db_subnet_group = true
  subnet_ids             = var.db-private-subnets


  # Database Deletion Protection
  deletion_protection = true
}
variable "db-instance-class" {
  
}
