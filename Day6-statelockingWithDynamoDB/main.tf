resource "aws_vpc" "name" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name="Dvpc"
  }
}
resource "aws_subnet" "name" {
  cidr_block = "10.0.0.0/24"
  vpc_id = aws_vpc.name.id
}

# resource "aws_instance" "name" {
#   subnet_id = aws_subnet.name.id
#   instance_type = "t3.micro"
#   ami = "ami-03caad32a158f72db"
#   tags = {
#     Name="Dharma"
#   }
# }