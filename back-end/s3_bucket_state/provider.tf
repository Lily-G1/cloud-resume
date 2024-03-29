terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.24.0"
    }
  }
}

provider "aws" {
  region                   = var.aws_region
  shared_credentials_files = [var.aws_credentials]
}