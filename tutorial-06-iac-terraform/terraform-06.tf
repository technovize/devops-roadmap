# Exercise: Complete this Terraform configuration
# File: main.tf

terraform {
  required_version = ">= 1.7.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      # TODO: pin to version ~> 5.0
    }
  }
}

provider "aws" {
  # TODO: set region from variable
}

# TODO: create a VPC with cidr_block from variable
# TODO: create 2 public subnets in different AZs
# TODO: create 2 private subnets in different AZs
# TODO: create an Internet Gateway
# TODO: create a public route table with a route to the IGW
# TODO: associate the public subnets with the public route table
# TODO: output the VPC ID and subnet IDs

variable "aws_region"   { default = "us-east-1" }
variable "vpc_cidr"     { default = "10.0.0.0/16" }
variable "project_name" { default = "terraform-lab" }
