variable "vpc-name" {
}
variable "vpc-cidr" {
}
variable "azs" {
  type = list(string)
}
variable "private-subnet-cidr" {
  type = list(string)
}
variable "public-subnet-cidr" {
  type = list(string)
}