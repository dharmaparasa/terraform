terraform {
  backend "s3" {
    bucket = "dharma-1234567890"
    key = "dharma/terraform.tfstate"
    region = "us-west-2"
  }
}