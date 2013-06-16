##################################
# kDeploy dependencies
##################################

package "libpq-dev"
package "python-dev"
package "python-setuptools"

execute "Update distribute" do
    user "root"
    command "easy_install -U distribute"
end

easy_install_package "psycopg2"
easy_install_package "MySQL-python"

##################################
# Hosting dir's
##################################

%w{/etc/apache2/conf/projects.d /etc/apache2/logs /opt/nowebsite}.each do |dir|
  directory dir do
      owner "root"
      group value_for_platform(
                            "mac_os_x" => { "default" => "admin" },
                            "default" => "root"
                          )
      mode 0777
      action :create
      recursive true
  end
end

directory "/opt/jdk" do
  owner "root"
  group "root"
  mode 0755
  action :create
end

link "/opt/jdk/default" do
  to "/usr/lib/jvm/java-7-openjdk-amd64"
  not_if "test -L /opt/jdk/default"
end

%w{/etc/apache2/conf/projects.d/namevirtualhosts /etc/apache2/workers.properties}.each do |dir|
  file dir do
    owner "root"
    group value_for_platform(
                            "mac_os_x" => { "default" => "admin" },
                            "default" => "root"
                          )
    mode 0777
    action :touch
  end
end

#Create the project directory
directory "/home/projects" do
  owner "root"
  mode "0777"
  action :create
  recursive true
end

#Create the backupped-projects directory
directory "/home/backupped-projects" do
  owner "root"
  mode "0777"
  action :create
  recursive true
end

##################################
# kDeploy Apache configuration
##################################

template "/etc/apache2/conf.d/kdeploy.conf" do
  source "apache2-kdeploy.conf.erb"
  owner "root"
  mode "0644"
  notifies :restart, "service[apache2]"
end

template "/etc/php5/conf.d/99-kunstmaan.ini" do
  source "php90kunstmaan.erb"
  owner "root"
  mode "0755"
end

template "/etc/php5/conf.d/apc.ini" do
    source "apc.ini.erb"
    owner "root"
    mode "0755"
end

##################################
# kDeploy
##################################

cookbook_file "#{Chef::Config[:file_cache_path]}/kDeploy.tar.gz" do
  source "kDeploy.tar.gz"
  mode 0755
  owner "root"
  group "root"
end

execute "Extract kDeploy" do
  cwd "/opt"
  command "tar xzf #{Chef::Config[:file_cache_path]}/kDeploy.tar.gz"
  not_if 'test -f /opt/kDeploy/tools/maintenance.py'
end

#Set the config.xml file with the correct parameters
template "/opt/kDeploy/tools/config.xml" do
  source "kdeploy.conf.erb"
  owner "root"
  mode "0755"
  variables(
    :password => node["percona"]["server"]["root_password"],
    :develmode => true,
    :hostname => node["set_fqdn"]
  )
end

#Configure the hupapache and logrotate
script "configure hupapache" do
    interpreter "bash"
    cwd "/opt/kDeploy/tools"
    code <<-EOH
        gcc -o hupapache hupapache.c
        chmod u+s hupapache
    EOH
end
script "configure logrotate" do
    interpreter "bash"
    cwd "/opt/kDeploy/tools"
    code <<-EOH
        gcc -o logrotate logrotate.c
        chmod u+s logrotate
    EOH
end
