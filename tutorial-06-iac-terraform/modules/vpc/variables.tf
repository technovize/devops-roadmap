variable "project_name" { type = string }
variable "environment"  { type = string }
variable "vpc_cidr"     { type = string }
variable "az_count"     { type = number; default = 3 }

# modules/vpc/main.tf
resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  tags = { Name = "${var.project_name}-${var.environment}-vpc" }
}
# ... subnet, IGW, NAT resources ...

# modules/vpc/outputs.tf
output "vpc_id"             { value = aws_vpc.this.id }
output "public_subnet_ids"  { value = aws_subnet.public[*].id }
output "private_subnet_ids" { value = aws_subnet.private[*].id }
