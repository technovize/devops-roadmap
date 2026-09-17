# Install required packages
%w[nginx python3 python3-pip git].each do |pkg|
  package pkg do
    action :install
  end
end

# Create the application user
user 'myapp' do
  system true
  home '/opt/myapp'
  shell '/bin/bash'
  action :create
end

# Create the application directory
directory '/opt/myapp' do
  owner 'myapp'
  group 'myapp'
  mode '0755'
  action :create
end

# Deploy Nginx configuration from a template
template '/etc/nginx/nginx.conf' do
  source 'nginx.conf.erb'
  owner 'root'
  group 'root'
  mode '0644'
  variables(
    app_port: node['myapp']['app_port'],
    app_user: node['myapp']['app_user']
  )
  notifies :restart, 'service[nginx]', :delayed
end

# Ensure Nginx is running
service 'nginx' do
  action [:enable, :start]
end
