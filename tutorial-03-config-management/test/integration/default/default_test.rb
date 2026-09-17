describe package('nginx') do
  it { should be_installed }
end

describe service('nginx') do
  it { should be_enabled }
  it { should be_running }
end

describe file('/etc/nginx/nginx.conf') do
  it { should exist }
  its('owner') { should eq 'root' }
  its('mode') { should cmp '0644' }
end

describe port(80) do
  it { should be_listening }
end
