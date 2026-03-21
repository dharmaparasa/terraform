resource "aws_vpc" "name" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name="Dharma"
  }
}

resource "aws_subnet" "sub1" {
  vpc_id = aws_vpc.name.id
  cidr_block = "10.0.0.0/24"
  availability_zone = "us-east-1a"
  tags  ={
    Name="us-east-2a-public"
  }
}
resource "aws_subnet" "sub2" {
  vpc_id = aws_vpc.name.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1b"
  tags = {
    Name="us-east-2b-private"
  }
}

#Creating and attaching Internet Gateway
resource "aws_internet_gateway" "name" {
  vpc_id = aws_vpc.name.id
  tags = {
    Name="DIG"
  }
}

#Edit routes & Add internet gateway
resource "aws_route_table" "name" {
  vpc_id = aws_vpc.name.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.name.id
  }
}

#Edit Subnet Associations & add subnet to a routetable
resource "aws_route_table_association" "name" {
  route_table_id = aws_route_table.name.id
  #assocating sub1 only and hence sub1 became public
  subnet_id = aws_subnet.sub1.id
}

resource "aws_security_group" "name" {
  vpc_id = aws_vpc.name.id
  name = "DSG"
  description = "Its My world"
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "name" {
  ami = "ami-02dfbd4ff395f2a1b"
  instance_type = "t3.micro"
  subnet_id = aws_subnet.sub1.id
  tags = {
    Name="DharmaInstance"
  }
}
