include_recipe "php-fpm::service"

instance_layer = node["opsworks"]["instance"]["layers"]

node[:deploy].each do |application, deploy_data|

  app_role = deploy_data[:deploy_layer]

  if !instance_layer.include?("develop")

    Chef::Log.debug("[LEADRUSH] PRODUCTION MODE //  APP ROLE: #{app_role} ON LAYER: #{instance_layer}")

    if !instance_layer.include?(app_role)
        Chef::Log.debug("[LEADRUSH] SKIPPING APP #{application} DEPLOYMENT - INVALID ROLE FOR THIS INSTANCE")
        next
    end

    deploy_type[:domains] = deploy_data[:domains]
    deploy_type[:branch] = "master"

  else

    deploy_type[:domains] = deploy_data[:beta_domains]
    deploy_type[:branch] = "develop"

  end  

  Chef::Log.debug("[LEADRUSH] DEPLOYING: #{application} on  #{deploy_type[:domains]} with branch #{deploy_type[:branch]}")
  Chef::Log.debug(deploy_type)


  ci_deploy_dir do
    user deploy_data[:user]
    group deploy_data[:group]
    path deploy_data[:deploy_to]
  end

  leadrush_deploy do
    app application
    deploy_data deploy_data
    deploy_type deploy_type
  end

  ci_web_app application do
    application deploy_data
    deploy_type deploy_type
    cookbook "nginx-app"
  end

end

execute "nginx restart" do
  command "/etc/init.d/nginx restart"
end