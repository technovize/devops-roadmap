locals {
  env_config = {
    staging = {
      db_instance_class   = "db.t3.small"
      eks_node_count      = 2
      multi_az            = false
    }
    production = {
      db_instance_class   = "db.r6g.xlarge"
      eks_node_count      = 6
      multi_az            = true
    }
  }

  config = local.env_config[terraform.workspace]
}

resource "aws_db_instance" "main" {
  instance_class = local.config.db_instance_class
  multi_az       = local.config.multi_az
  # ...
}
