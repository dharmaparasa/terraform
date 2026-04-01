variable "ingress-rule-map" {
  type = map(string)
  default = {
    22 = "0.0.0.0/0" 
    80 = "192.168.0.0/16"}
}
variable "sg-vpc" {
}

variable "sg-name" {
  
}
variable "name-tag" {
  
}
