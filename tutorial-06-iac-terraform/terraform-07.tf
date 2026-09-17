# Create module structure
mkdir -p modules/vpc
touch modules/vpc/{main.tf,variables.tf,outputs.tf,README.md}

# modules/vpc/variables.tf — define: project_name, vpc_cidr, az_count, environment
# modules/vpc/main.tf — move all resources here
# modules/vpc/outputs.tf — expose: vpc_id, public_subnet_ids, private_subnet_ids

# Root configuration using the module:
cat > root-main.tf << 'EOF'
module "vpc_staging" {
  source       = "./modules/vpc"
  project_name = "myapp"
  environment  = "staging"
  vpc_cidr     = "10.1.0.0/16"
  az_count     = 2
}

module "vpc_production" {
  source       = "./modules/vpc"
  project_name = "myapp"
  environment  = "production"
  vpc_cidr     = "10.0.0.0/16"
  az_count     = 3
}

output "staging_vpc_id"    { value = module.vpc_staging.vpc_id }
output "production_vpc_id" { value = module.vpc_production.vpc_id }
EOF

terraform init
terraform plan
