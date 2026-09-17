# Install Checkov
pip install checkov

# Scan your Terraform directory
checkov -d . --framework terraform

# Review the findings and fix them:
# Common findings to fix in Lab 6.1 code:

# CKV_AWS_130: VPC should not have public subnets
# (This is a warning — public subnets are intentional here)
# Add a skip comment to silence it:
resource "aws_subnet" "public" {
  # checkov:skip=CKV_AWS_130:Public subnets required for load balancers
  ...
}

# CKV2_AWS_12: Ensure VPC has flow logs enabled
# Fix by adding:
resource "aws_flow_log" "main" {
  iam_role_arn    = aws_iam_role.flow_log.arn
  log_destination = aws_cloudwatch_log_group.flow_log.arn
  traffic_type    = "ALL"
  vpc_id          = aws_vpc.main.id
}

# Run again to verify fixes
checkov -d . --framework terraform --compact
