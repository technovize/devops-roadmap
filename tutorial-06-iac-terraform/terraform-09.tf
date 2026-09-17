# Prevent this with lifecycle rules on critical resources
resource "aws_db_instance" "main" {
  # ...
  lifecycle {
    prevent_destroy = true
  }
}

# Also: use workspace-specific destroy protection
# Never run terraform destroy in the production workspace
# Add to your CI/CD pipeline:
if [[ "$(terraform workspace show)" == "production" ]]; then
  echo "ERROR: terraform destroy not allowed in production workspace"
  exit 1
fi
