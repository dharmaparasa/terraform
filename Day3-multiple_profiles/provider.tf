provider "aws" {
  
}

provider "aws" {
  profile = "uat"
  alias = "uat"
  region = "us-west-2"
}