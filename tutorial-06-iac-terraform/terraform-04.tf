resource "aws_db_instance" "main" {
  # ...
  lifecycle {
    prevent_destroy       = true
    ignore_changes        = [password]   # Ignore out-of-band password rotations
  }
}
