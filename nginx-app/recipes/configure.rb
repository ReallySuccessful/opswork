include_recipe "nginx-app::server"
include_recipe "php-fpm::service"

instance_roles   = get_instance_roles()
cluster_name     = get_cluster_name()
app_access_log   = "off"
nginx_config_dir = node["nginx-app"]["config_dir"]

# need to do this better
if !node.attribute?("docroot") || node["docroot"].empty?
  node.set["docroot"] = 'www'
end

# password protect?
password_protected = false

# put this in attributes
nginx_config = "easybib.com.conf.erb"

node["deploy"].each do |application, deploy|

  php_upstream = "unix:/var/run/php-fpm/#{node["php-fpm"]["user"]}"

  template "#{nginx_config_dir}/sites-enabled/#{application}.conf" do
    source nginx_config
    mode   "0755"
    owner  node["nginx-app"]["user"]
    group  node["nginx-app"]["group"]
    variables(
      :access_log         => app_access_log,
      :deploy             => deploy,
      :application        => application,
      :password_protected => password_protected,
      :config_dir         => nginx_config_dir,
      :php_upstream       => php_upstream
    )
    notifies :restart, "service[nginx]", :delayed
  end

end
