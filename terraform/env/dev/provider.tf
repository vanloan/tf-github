terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.67.0"
    }

    tls = {
      source = "hashicorp/tls"
      version = ">= 4.1.0"
    }
  }

  required_version = ">= 1.0"
}

provider "aws" {
  region = "us-west-2"
}
