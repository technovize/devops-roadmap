terraform {
  required_version = ">= 1.7.0"   # Pin the minimum Terraform version

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"          # Allow 5.x, not 6.x
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.27"
    }
  }

  # Remote state backend (covered in Section 2.6)
  backend "s3" {
    bucket         = "my-terraform-state"
    key            = "production/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform-state-lock"
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
