include_recipe "nginx::service"

config_path = "#{node[:nginx][:dir]}/sites-enabled/phpmyadmin.conf"

template config_path do
  source "nginx/phpmyadmin.conf.erb"
  owner "root"
  group "root"
  mode 0644
  if File.exists?(config_path)
    notifies :reload, resources(:service => "nginx"), :delayed
  end
end