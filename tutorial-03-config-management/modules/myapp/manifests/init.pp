class myapp (
  String $app_user    = 'myapp',
  Integer $app_port   = 8000,
  String $db_host     = 'localhost',
) {

  # Ensure the app user exists
  user { $app_user:
    ensure => present,
    system => true,
    home   => "/opt/${app_user}",
    shell  => '/bin/bash',
  }

  # Create the application directory
  file { "/opt/${app_user}":
    ensure  => directory,
    owner   => $app_user,
    mode    => '0755',
    require => User[$app_user],
  }

  # Install required packages
  package { ['python3', 'python3-pip', 'git']:
    ensure => present,
  }

  # Deploy application service
  include myapp::service
}
