terraform {
  backend "s3" {
    bucket  = "loanvt"
    region  = "us-west-2"
    key     = "terraform.tfstate"
    encrypt = true
  }
}

provider "aws" {
  region = "us-west-2"
}