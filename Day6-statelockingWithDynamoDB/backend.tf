terraform {
  backend "s3" {
    bucket = "dharma-1234567890"
    key = "karthik/terraform.tfstate"
    region = "us-west-2"
    dynamodb_table = "juststatelock"
    encrypt = true
  }
}