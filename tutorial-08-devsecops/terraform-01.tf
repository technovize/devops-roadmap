# (no) CKV_AWS_18: S3 bucket without access logging
resource "aws_s3_bucket" "data" {
  bucket = "my-data"
}

# (yes) Fix: Enable access logging
resource "aws_s3_bucket_logging" "data" {
  bucket        = aws_s3_bucket.data.id
  target_bucket = aws_s3_bucket.logs.id
  target_prefix = "s3-access-logs/"
}

# (no) CKV_AWS_8: EC2 instance without IMDSv2
resource "aws_instance" "app" {
  ami           = "ami-0abcdef1234567890"
  instance_type = "t3.medium"
}

# (yes) Fix: Require IMDSv2 (prevents SSRF-based metadata credential theft)
resource "aws_instance" "app" {
  ami           = "ami-0abcdef1234567890"
  instance_type = "t3.medium"

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"    # Require IMDSv2
    http_put_response_hop_limit = 1
  }
}
