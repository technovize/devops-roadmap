# Error: "Module not installed" after moving module directory

# Fix: Re-run init after any module source changes
terraform init

# If using Git source:
module "vpc" {
  source = "git::https://github.com/myorg/modules.git//vpc?ref=v1.2.0"
}
# Run: terraform init -upgrade
