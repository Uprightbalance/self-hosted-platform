terraform {
  # 1. Matches your local computer engine version safely
  required_version = ">= 1.16.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      # 2. Locks you safely into your current version 5 setup
      version = "~> 5.100" 
    }
  }
}

provider "aws" {
  region = var.aws_region
}

