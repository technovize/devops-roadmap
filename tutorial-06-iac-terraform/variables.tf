variable "aws_region" {
  description = "AWS region to deploy resources into"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Deployment environment: staging or production"
  type        = string
  validation {
    condition     = contains(["staging", "production"], var.environment)
    error_message = "Environment must be 'staging' or 'production'."
  }
}

variable "project_name" {
  description = "Project name — used in resource naming and tags"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "allowed_cidr_blocks" {
  description = "List of CIDR blocks allowed to reach the application"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "db_instance_class" {
  description = "RDS instance type"
  type        = string
  default     = "db.t3.medium"
  sensitive   = false
}

variable "db_password" {
  description = "Database master password — provide via TF_VAR_db_password env var"
  type        = string
  sensitive   = true   # Redacted from all Terraform output and logs
}
