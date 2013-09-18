include_recipe "php-fpm::service"

instance_roles = get_instance_roles()
cluster_name   = get_cluster_name()

node["deploy"].each do |application, deploy|

  Chef::Log.info("deploy::leadrush - app: #{application}, role: #{instance_roles}")


end
