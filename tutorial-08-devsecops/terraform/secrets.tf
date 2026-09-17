resource "aws_secretsmanager_secret" "db_credentials" {
  name                    = "myapp/production/database"
  description             = "Production database credentials for MyApp"
  recovery_window_in_days = 30    # Prevent immediate permanent deletion

  tags = {
    Application = "myapp"
    Environment = "production"
  }
}

resource "aws_secretsmanager_secret_version" "db_credentials" {
  secret_id = aws_secretsmanager_secret.db_credentials.id
  secret_string = jsonencode({
    username = "myapp_user"
    password = var.db_password   # Initial value — will be rotated
    host     = aws_db_instance.main.address
    port     = 5432
    dbname   = "myapp_production"
  })
}

# Automatic rotation every 30 days
resource "aws_secretsmanager_secret_rotation" "db_credentials" {
  secret_id           = aws_secretsmanager_secret.db_credentials.id
  rotation_lambda_arn = aws_lambda_function.secret_rotation.arn

  rotation_rules {
    automatically_after_days = 30
  }
}
