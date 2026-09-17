# main.tf — root configuration

module "vpc" {
  source = "./modules/vpc"       # Local path

  project_name = var.project_name
  environment  = var.environment
  vpc_cidr     = "10.0.0.0/16"
  az_count     = 3
}

module "database" {
  source = "./modules/rds"

  project_name       = var.project_name
  environment        = var.environment
  vpc_id             = module.vpc.vpc_id          # Use output from vpc module
  subnet_ids         = module.vpc.private_subnet_ids
  db_password        = var.db_password
}

# Using a public module from the Terraform Registry
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = "${var.project_name}-${var.environment}"
  cluster_version = "1.29"
  vpc_id          = module.vpc.vpc_id
  subnet_ids      = module.vpc.private_subnet_ids
}
