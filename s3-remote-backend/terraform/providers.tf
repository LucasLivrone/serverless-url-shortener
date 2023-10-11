# Provider version
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.15.0"
    }
  }
}

# Provider configuration
provider "aws" {
  region = var.aws_region
}