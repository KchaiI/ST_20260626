terraform {
  required_version = ">= 1.6.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.61"
    }
  }

  backend "s3" {
    bucket         = "project-tfstate-dfb78a78"
    key            = "project/terraform.tfstate"
    region         = "ap-northeast-1"
    dynamodb_table = "project-tfstate-lock"
    encrypt        = true
  }
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Project     = var.project_name
      Environment = var.environment
      ManagedBy   = "Terraform"
    }
  }
}