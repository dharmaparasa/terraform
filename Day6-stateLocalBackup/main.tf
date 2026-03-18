resource "aws_vpc" "name" {
  cidr_block = "10.0.0.0/16"
}
resource "aws_subnet" "name" {
  vpc_id = aws_vpc.name.id
  cidr_block = "10.0.0.0/24"
}

resource "aws_instance" "name" {
  subnet_id = aws_subnet.name.id
  ami="ami-03caad32a158f72db"
  instance_type = "t3.nano"
  #changing this instance type created a terraform.tfstate.backup file with last value stored
}