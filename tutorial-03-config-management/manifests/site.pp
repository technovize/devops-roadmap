# Apply to all nodes
node default {
  include base_security
  include monitoring_agent
}

# Apply only to web servers
node /^web-\d+\.myapp\.com$/ {
  include myapp
  include nginx
}

# Apply only to database servers
node /^db-\d+\.myapp\.com$/ {
  include postgresql
  include backup_agent
}
