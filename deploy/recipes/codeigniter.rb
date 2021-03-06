include_recipe "php-fpm::service"

instance_layer = node["opsworks"]["instance"]["layers"]

all_results = {}

node[:deploy].each do |application, deploy_info|

  # merge deploy json
  deploy_data = deploy_info.merge(node[:deploy_config][application])

  Chef::Log.debug("[LEADRUSH] MERGED APP SETTINGS");
  Chef::Log.debug(deploy_data);

  app_role = deploy_data[:deploy_layer]

  if !instance_layer.include?("develop")

    Chef::Log.debug("[LEADRUSH] PRODUCTION MODE //  APP ROLE: #{app_role} ON LAYER: #{instance_layer}")

    if !instance_layer.include?(app_role)
        Chef::Log.debug("[LEADRUSH] SKIPPING APP #{application} DEPLOYMENT - INVALID ROLE FOR THIS INSTANCE")
        next
    end

    deploy_domains = deploy_data[:domains]
    deploy_branch = "master"

  else

    deploy_domains= deploy_data[:beta_domains]
    deploy_branch = "develop"

  end  

  Chef::Log.debug("[LEADRUSH] DEPLOYING: #{application} on  #{deploy_domains.first} with branch #{deploy_branch}")

  ci_deploy_dir do
    user deploy_data[:user]
    group deploy_data[:group]
    path deploy_data[:deploy_to]
  end

  leadrush_deploy do
    app application
    deploy_data deploy_data
    deploy_branch deploy_branch    
  end

  ci_web_app application do
    application deploy_data
    deploy_domains deploy_domains
    cookbook "nginx-app"
    environment "production"

  end

end

execute "nginx restart" do
  command "/etc/init.d/nginx restart"
end