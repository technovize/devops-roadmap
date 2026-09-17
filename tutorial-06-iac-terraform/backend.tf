terraform {
  backend "s3" {
    bucket         = "myorg-terraform-state"       # Must exist before init
    key            = "myapp/production/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true                          # Encrypt state at rest
    kms_key_id     = "arn:aws:kms:us-east-1:123456789:key/abc-123"

    # DynamoDB table for state locking — prevents concurrent applies
    dynamodb_table = "terraform-state-locks"
  }
}
