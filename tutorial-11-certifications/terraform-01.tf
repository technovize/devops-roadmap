# Topics the exam tests — build practical experience with each of these:

# 1. Data sources
data "aws_ami" "ubuntu" {
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
  owners = ["099720109477"]
}

# 2. Local values
locals {
  common_tags = {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

# 3. Dynamic blocks
resource "aws_security_group" "web" {
  name = "web-sg"
  dynamic "ingress" {
    for_each = var.allowed_ports
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
}

# 4. For expressions
output "instance_ids" {
  value = [for instance in aws_instance.web : instance.id]
}

# 5. Lifecycle rules
resource "aws_db_instance" "main" {
  # ...
  lifecycle {
    prevent_destroy       = true
    ignore_changes        = [password, engine_version]
    create_before_destroy = false
  }
}

# 6. Terraform workspaces
# terraform workspace new staging
# terraform workspace select production
# resource naming using: "${var.name}-${terraform.workspace}"
