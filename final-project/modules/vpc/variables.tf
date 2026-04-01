variable "vpc-name" {
}
variable "vpc-cidr" {
}
variable "azs" {
  type = list(string)
  default = ["us-east-1a", "us-east-1b"]
}
variable "private-subnet-cidr" {
  type = list(string)
  default = ["10.0.1.0/24", "10.0.2.0/24"]
}
variable "public-subnet-cidr" {
  type = list(string)
  default = ["10.0.3.0/24", "10.0.4.0/24"]
}