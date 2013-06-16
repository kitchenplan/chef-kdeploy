# Apt

include_recipe "apt::default"

# Prerequisites for compilation

include_recipe "build-essential::default"

# SSH settings

ssh_known_hosts_entry 'github.com'
include_recipe "root_ssh_agent::ppid"
include_recipe "root_ssh_agent::env_keep"

# Apache

include_recipe "apache2::default"

# PHP

apt_repository "php-5.4" do
  uri "http://ppa.launchpad.net/ondrej/php5/ubuntu"
  distribution node['lsb']['codename']
  components ["main"]
  keyserver "keyserver.ubuntu.com"
  key "E5267A6C"
end

include_recipe "php::default"
include_recipe "php::module_mysql"
include_recipe "php::module_apc"
include_recipe "php::module_curl"
include_recipe "php::module_gd"
include_recipe "php::module_xml"
include_recipe "php::module_memcache"
include_recipe "php::module_intl"
include_recipe "php::module_mcrypt"

include_recipe "composer::default"

# MySQL

include_recipe "percona::server"
include_recipe "percona::toolkit"
include_recipe "percona::configure_server"

# Memcached

include_recipe "memcached::default"

# Support applications

include_recipe "imagemagick::devel"
include_recipe "java::openjdk"

chef_gem "sass" do
  action :install
end

# Locales

include_recipe "locale-gen::default"

# kDeploy

include_recipe "kdeploy::kdeploy"
