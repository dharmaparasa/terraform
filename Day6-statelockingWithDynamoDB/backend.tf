terraform {
  backend "s3" {
    bucket = "dharma-1234567890"
    key = "karthik/terraform.tfstate"
    region = "us-east-1"
    dynamodb_table = "juststatelock"
    encrypt = true
  }
}