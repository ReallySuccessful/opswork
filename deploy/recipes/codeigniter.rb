include_recipe "php-fpm::service"

instance_layer = node["opsworks"]["instance"]["layers"]

node[:deploy].each do |application, deploy|

  app_role = deploy[:deploy_to]

  if !instance_layer.include?("develop")

    Chef::Log.debug("[LEADRUSH] PRODUCTION MODE //  APP ROLE: #{app_role} ON LAYER: #{instance_layer}")

    if !instance_layer.include?(app_role)
        Chef::Log.debug("[LEADRUSH] SKIPPING APP #{application} DEPLOYMENT - INVALID ROLE FOR THIS INSTANCE")
        next
    end

  else

    Chef::Log.debug("[LEADRUSH] DEVELOPMENT MODE // APP ROLE: #{app_role} ON LAYER: #{instance_layer}")

    node.deploy[:revision] = "develop"
    node.deploy[:domains] = deploy[:beta_domains]

  end  

  ci_deploy_dir do
    user deploy[:user]
    group deploy[:group]
    path deploy[:deploy_to]
  end

  leadrush_deploy do
    app application
    deploy_data deploy
  end

  ci_web_app application do
    application deploy
    cookbook "nginx-app"
  end

end

execute "nginx restart" do
  command "/etc/init.d/nginx restart"
end