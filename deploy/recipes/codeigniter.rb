include_recipe "php-fpm::service"

instance_layer = node["opsworks"]["instance"]["layers"]

all_results = {}

node[:deploy].each do |application, deploy_data|

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
  end

end


ruby_block "Send message to MAMA once everything is done and restart NGINX :)" do
  block do

    node[:deploy].each do |application, deploy_data|
      if !instance_layer.include?("develop")
        if !instance_layer.include?(app_role)
            next
        end

        deploy_domains = deploy_data[:domains]
        deploy_branch = "master"

      else

        deploy_domains= deploy_data[:beta_domains]
        deploy_branch = "develop"

      end  
      find = Mixlib::ShellOut.new("cd /srv/www/#{application}/current && git describe --tags")
      find.run_command    
      tag = find.stdout
      find = Mixlib::ShellOut.new("cd /srv/www/#{application}/current && git log --oneline -1")
      find.run_command    
      last_commit = find.stdout

      all_results[application] = {
        "branch" => deploy_branch,
        "domains" => deploy_domains,
        "running_version" => tag,
        "last_commit" => last_commit  
      }     
       
    end  

    message_to_send = { 
      :message => "Deployment complete,",
      :applications => all_results, 
      :server_details => {
          :hostname => node[:opsworks][:instance][:hostname],
          :instance_id => node[:opsworks][:instance][:id],
          :instance_type => node[:opsworks][:instance][:instance_type],
          :public_ip => node[:opsworks][:instance][:ip],
          :layer => instance_layer
      } 
    }

    # send post to MAMA
    http_request "Alerting mama !" do
      action :post
      url "http://mamabot.herokuapp.com/webhook/dev"
      message message_to_send
    end

    execute "nginx restart" do
      command "/etc/init.d/nginx restart"
    end

  end
end

