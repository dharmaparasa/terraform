variable "ami_id" {
  description = "ami_id amazone Linux lldsdf"
  default = ""
  type = string
}

variable "instance_type" {
    description = "type of instance"
    default = "t2.micro"
    type = string
  
}