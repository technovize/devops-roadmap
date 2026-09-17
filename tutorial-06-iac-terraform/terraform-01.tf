# Terraform (declarative) — "I want an S3 bucket named my-app-data"
resource "aws_s3_bucket" "app_data" {
  bucket = "my-app-data"
}
