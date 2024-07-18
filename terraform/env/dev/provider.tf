terraform {
  backend "s3" {
    # profile = "test"
    bucket  = "loanvt"
    region  = "us-west-2"
    key     = "dev/terraform.tfstate"
    encrypt = true
  }
}

provider "aws" {
  region = "us-west-2"
  # profile = "test"
}