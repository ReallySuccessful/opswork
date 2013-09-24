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

  else

    Chef::Log.debug("[LEADRUSH] DEVELOPMENT MODE // APP ROLE: #{app_role} ON LAYER: #{instance_layer}")
    
    Chef::Log.debug(deploy_data)
    

    deploy_data.override['revision'] = "develop"
    deploy_data.override['domains'] = deploy_data[:domains]

    Chef::Log.debug("[LEADRUSH] DEPLOY #{deploy_data[:revision]} BETA DOMAINS:")
    Chef::Log.debug(deploy_data[:domains])

  end  

  ci_deploy_dir do
    user deploy_data[:user]
    group deploy_data[:group]
    path deploy_data[:deploy_to]
  end

  leadrush_deploy do
    app application
    deploy_data deploy_data
  end

  ci_web_app application do
    application deploy_data
    cookbook "nginx-app"
  end

end

execute "nginx restart" do
  command "/etc/init.d/nginx restart"
end