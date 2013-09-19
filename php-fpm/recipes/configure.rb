include_recipe "php-fpm::service"

etc_cli_dir = "/etc/php5/cli/"
etc_fpm_dir = "/etc/php5/fpm/"
conf_cli    = "php-cli.ini"
conf_fpm    = "php.ini"

display_errors = "Off"

template "#{etc_fpm_dir}/#{conf_fpm}" do
  mode     "0755"
  source   "php.ini.erb"
  variables(
    :enable_dl      => 'Off',
    :memory_limit   => node["php-fpm"]["memorylimit"],
    :display_errors => display_errors
  )
  owner    node["php-fpm"]["user"]
  group    node["php-fpm"]["group"]
  notifies :restart, "service[php5-fpm]", :delayed
end

template "#{etc_cli_dir}/#{conf_cli}" do
  mode "0755"
  source "php.ini.erb"
  variables(
    :enable_dl      => "On",
    :memory_limit   => '1024M',
    :display_errors => 'On'
  )
  owner node["php-fpm"]["user"]
  group node["php-fpm"]["group"]
end

template "#{etc_fpm_dir}/php-fpm.conf" do
  mode     "0755"
  source   "php-fpm.conf.erb"
  owner    node["php-fpm"]["user"]
  group    node["php-fpm"]["group"]
  notifies :restart, "service[php5-fpm]", :delayed
end

template "/etc/logrotate.d/php" do
  source "logrotate.erb"
  mode "0644"
  owner "root"
  group "root"
  notifies :enable, "service[php5-fpm]"
  notifies :start, "service[php5-fpm]"
end
