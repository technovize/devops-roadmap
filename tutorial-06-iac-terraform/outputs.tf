output "vpc_id" {
  description = "ID of the created VPC"
  value       = aws_vpc.main.id
}

output "public_subnet_ids" {
  description = "IDs of public subnets"
  value       = aws_subnet.public[*].id
}

output "rds_endpoint" {
  description = "RDS instance connection endpoint"
  value       = aws_db_instance.main.endpoint
  sensitive   = true   # Redacted from console output
}

output "eks_cluster_endpoint" {
  description = "EKS cluster API server endpoint"
  value       = aws_eks_cluster.main.endpoint
}
