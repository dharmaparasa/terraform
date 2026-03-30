//use locals

locals {
  # amiid="ami-03caad32a158f72db"
  amiid="ami-02dfbd4ff395f2a1b"
  amiid2="ami-014d82945a82dfba3"
  instance_type="t3.micro"
  instancetype2="t2.micro"
}

//target the already created subnet in oregon
data "aws_subnet" "name" {
  filter {
    name = "tag:Name"
    values = [ "dharma-subnet-public1-us-west-2a" ]
  }
}

//create an aws instance only (not s3 along with) in the given subnet by targetting
//targetting command -> terraform plan -target=aws_instance.name
resource "aws_instance" "name" {
  ami = local.amiid
  instance_type = local.instance_type
  subnet_id = data.aws_subnet.name.id
  depends_on = [ aws_s3_bucket.name ]
  tags ={
    Name="TerraformCreated"
  }
  
  # create life cycle rules for this instance
  lifecycle {
    # prevent_destroy = true
    ignore_changes = [tags,ami]
  }
  
}

//create an s3 block
resource "aws_s3_bucket" "name" {
  bucket = "narshdevlsflsdfjlfkf"
}


//Import state file of the resource already created on console
resource "aws_instance" "cc" {
  ami = local.amiid2
  instance_type = local.instancetype2
  tags = {
    Name="CreatedByConsole"
  }
}
import {
  to = aws_instance.cc
  id = "i-0bf5409451d8f7b27"
}