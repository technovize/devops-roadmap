# Ensure Nginx package is installed
package { 'nginx':
  ensure => present,
}

# Ensure Nginx service is running and starts on boot
service { 'nginx':
  ensure  => running,
  enable  => true,
  require => Package['nginx'],  # Must install before starting
}

# Deploy configuration file
file { '/etc/nginx/nginx.conf':
  ensure  => file,
  content => template('myapp/nginx.conf.erb'),
  owner   => 'root',
  group   => 'root',
  mode    => '0644',
  require => Package['nginx'],
  notify  => Service['nginx'],  # Restart Nginx if this file changes
}
