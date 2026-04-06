variable "alb-sgs" {
  type = list(string)
}
variable "alb-public-subnets" {
  type = list(string)
}
variable "alb-vpc-id" {
  
}
variable "alb-name" {
  
}
variable "ec2-instance-id" {
  
}

variable "target_port" {
  
}
variable "internal_lb" {
  default = false
}