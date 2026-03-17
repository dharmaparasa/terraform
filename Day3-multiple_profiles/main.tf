resource "aws_instance" "S1" {
  ami = var.ami_id
  instance_type = var.instance_type
  tags = {
    Name="Dharma"
  }
}



resource "aws_subnet" "Subnet1" {
  vpc_id = aws_vpc.V1.id
  cidr_block = "10.0.0.0/24"
    provider = aws.uat
  tags = {
    Name="Dharma Uber"
  }
}


resource "aws_instance" "S2" {
  subnet_id = aws_subnet.Subnet1.id
  ami="ami-03caad32a158f72db"
  instance_type = "t3.medium"
  provider = aws.uat
  tags = {
    Name="oregonD"
  }
}

resource "aws_vpc" "V1" {
  cidr_block = "10.0.0.0/16"
  provider = aws.uat
  tags = {
    Name="OrgHarish"
  }
}