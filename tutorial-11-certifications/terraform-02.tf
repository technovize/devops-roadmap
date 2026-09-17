# Experiment 1: Resource Dependencies
# Question: In what order will these resources be created?
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "public" {
  vpc_id     = aws_vpc.main.id    # Implicit dependency
  cidr_block = "10.0.1.0/24"
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id        # Also depends on vpc
}

# Answer: VPC is created first (both subnet and IGW depend on it)
# Subnet and IGW can be created in parallel (no dependency between them)
# Run: terraform apply and observe the parallel creation in the output

---

# Experiment 2: Count vs For_each
# Create 3 subnets using count — observe the problem
resource "aws_subnet" "count_example" {
  count      = 3
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.${count.index}.0/24"
}
# Problem: Removing subnet[1] shifts indices — [2] becomes [1], destroying and recreating it

# Better: use for_each with a set
locals {
  subnet_cidrs = {
    "public-1" = "10.0.1.0/24"
    "public-2" = "10.0.2.0/24"
    "public-3" = "10.0.3.0/24"
  }
}
resource "aws_subnet" "foreach_example" {
  for_each   = local.subnet_cidrs
  vpc_id     = aws_vpc.main.id
  cidr_block = each.value
  tags       = { Name = each.key }
}
# Removing "public-2" only affects that one subnet — others unchanged

---

# Experiment 3: Lifecycle rules
resource "aws_db_instance" "db" {
  # ...
  lifecycle {
    prevent_destroy       = true    # Blocks terraform destroy
    ignore_changes        = [password]  # Ignores password changes after creation
    create_before_destroy = false   # Default: destroy old, create new
  }
}

# Test prevent_destroy:
# terraform destroy    # Should fail with "Error: Instance cannot be destroyed"

---

# Experiment 4: Output sensitivity
output "db_password" {
  value     = var.db_password
  sensitive = true              # Redacted in console output
}

# terraform apply
# Shows: db_password = <sensitive>
# terraform output db_password
# Shows the actual value (intentional — you asked for it)
