include_recipe "php-fpm::service"

instance_roles = get_instance_roles()
cluster_name   = get_cluster_name()

node["deploy"].each do |application, deploy|

  Chef::Log.info("deploy::easybib - app: #{application}, role: #{instance_roles}")

  next unless deploy["deploying_user"]
  next unless instance_roles.include?('opswork')

  Chef::Log.info("deploy::easybib - Deployment started.")
  Chef::Log.info("deploy::easybib - Deploying as user: #{deploy["user"]} and #{deploy["group"]}")

  opsworks_deploy_user do
    deploy_data deploy
    app application
  end

  opsworks_deploy_dir do
    user  deploy["user"]
    group deploy["group"]
    path  deploy["deploy_to"]
  end

  opsworks_deploy do
    deploy_data deploy
    app application
  end

  service "php-fpm" do
    action :reload
  end

end
