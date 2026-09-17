package terraform.required_tags

import input.resource_changes

required_tags := {"Project", "Environment", "ManagedBy", "Owner"}

violation[msg] {
  resource := resource_changes[_]
  resource.change.actions[_] == "create"
  resource.type == "aws_instance"

  missing := required_tags - {tag | resource.change.after.tags[tag]}
  count(missing) > 0

  msg := sprintf(
    "EC2 instance '%v' is missing required tags: %v",
    [resource.address, missing]
  )
}

violation[msg] {
  resource := resource_changes[_]
  resource.change.actions[_] == "create"
  resource.type == "aws_s3_bucket"

  not regex.match(`^myorg-[a-z0-9-]+-[a-z]+$`, resource.change.after.bucket)

  msg := sprintf(
    "S3 bucket '%v' does not match the naming convention: myorg-{name}-{env}",
    [resource.change.after.bucket]
  )
}
