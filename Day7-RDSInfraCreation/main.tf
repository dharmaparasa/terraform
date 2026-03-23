resource "aws_vpc" "dharmavpclocalname" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name="DharmaVPC"
  }
}

resource "aws_subnet" "sub1" {
  vpc_id = aws_vpc.dharmavpclocalname.id
  cidr_block = "10.0.0.0/24"
  availability_zone = "us-east-1a"
  tags = {
    Name="privateSubnet-1"
  }
}

resource "aws_subnet" "sub2" {
  vpc_id = aws_vpc.dharmavpclocalname.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1b"
  tags = {
    Name="privateSubnet-2"
  }
}

resource "aws_db_subnet_group" "sgroup" {
  subnet_ids = [ aws_subnet.sub1.id, aws_subnet.sub2.id ]
  name = "dharmasg"

}

resource "aws_db_instance" "db" {
    instance_class = "db.t3.micro"
    allocated_storage = 10
  db_subnet_group_name = aws_db_subnet_group.sgroup.id
  identifier = "dharmadb"
  engine = "mysql"
    engine_version = "8.0"
    username = "admin"
    manage_master_user_password = true


}

