# -- Security Group ---------------------------------------------------------
resource "aws_security_group" "rds" {
  name        = "${var.project_name}-${var.environment}-rds-sg"
  description = "Security group for RDS PostgreSQL instance"
  vpc_id      = aws_vpc.main.id

  # Allow inbound PostgreSQL only from the application security group
  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.app.id]
    description     = "PostgreSQL from application layer"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "${var.project_name}-${var.environment}-rds-sg" }
}

# -- Subnet Group -----------------------------------------------------------
resource "aws_db_subnet_group" "main" {
  name       = "${var.project_name}-${var.environment}-db-subnet-group"
  subnet_ids = aws_subnet.private[*].id    # Place RDS in private subnets

  tags = { Name = "${var.project_name}-${var.environment}-db-subnet-group" }
}

# -- Parameter Group --------------------------------------------------------
resource "aws_db_parameter_group" "postgres" {
  name   = "${var.project_name}-${var.environment}-postgres16"
  family = "postgres16"

  parameter {
    name  = "log_connections"
    value = "1"
  }

  parameter {
    name  = "log_disconnections"
    value = "1"
  }

  parameter {
    name  = "log_min_duration_statement"
    value = "1000"   # Log queries taking longer than 1 second
  }
}

# -- RDS Instance -----------------------------------------------------------
resource "aws_db_instance" "main" {
  identifier = "${var.project_name}-${var.environment}-postgres"

  # Engine
  engine         = "postgres"
  engine_version = "16.2"
  instance_class = var.db_instance_class

  # Storage
  allocated_storage     = 100
  max_allocated_storage = 1000   # Enable autoscaling up to 1TB
  storage_type          = "gp3"
  storage_encrypted     = true
  kms_key_id            = aws_kms_key.rds.arn

  # Credentials
  db_name  = replace(var.project_name, "-", "_")
  username = "postgres"
  password = var.db_password

  # Network
  db_subnet_group_name   = aws_db_subnet_group.main.name
  vpc_security_group_ids = [aws_security_group.rds.id]
  publicly_accessible    = false   # Never expose RDS to the internet

  # Availability and resilience
  multi_az               = var.environment == "production"   # Multi-AZ in production only
  parameter_group_name   = aws_db_parameter_group.postgres.name

  # Backup
  backup_retention_period   = var.environment == "production" ? 30 : 7
  backup_window             = "03:00-04:00"
  maintenance_window        = "mon:04:00-mon:05:00"
  delete_automated_backups  = false
  deletion_protection       = var.environment == "production"

  # Monitoring
  monitoring_interval = 60   # Enhanced Monitoring every 60 seconds
  monitoring_role_arn = aws_iam_role.rds_monitoring.arn
  enabled_cloudwatch_logs_exports = ["postgresql", "upgrade"]

  # Prevent accidental destruction in production
  lifecycle {
    prevent_destroy = true    # Remove this flag to allow deletion
  }

  tags = {
    Name = "${var.project_name}-${var.environment}-postgres"
  }
}
