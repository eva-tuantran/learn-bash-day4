# execute "Update yum Development Tools" do
  # command "yum -y groupupdate \"Development Tools\""
# end

%w{php php-mbstring php-pdo php-mysql php-xml}.each do |name|
  package name do
    action :install
  end
end
template "/etc/php.d/php.local.ini" do
  source "php.local.ini.erb"
  owner "vagrant"
  group "vagrant"
  variables(
    :php => node['php']
  )
end

package "httpd" do
  action :install
end
template "/etc/httpd/conf/httpd.conf" do
  source "httpd.conf.erb"
end
service "httpd" do
  action [:start, :enable]
end

%w{mysql mysql-server}.each do |name|
  package name do
    action :install
  end
end
template "/etc/my.cnf" do
  source "my.cnf.erb"
end
service "mysqld" do
  action [:start, :enable]
end

