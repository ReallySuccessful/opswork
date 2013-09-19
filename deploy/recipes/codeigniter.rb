include_recipe "php-fpm::service"

node[:deploy].each do |application, deploy|
  ci_deploy_dir do
    user deploy[:user]
    group deploy[:group]
    path deploy[:deploy_to]
  end

  opsworks_deploy do
    app application
    deploy_data deploy
  end

  ci_web_app application do
    application deploy
    cookbook "nginx-app"
  end

  ## we take the assets dir and create a sym link so they are available in all release but we always keep the last version (overwirted)
  execute "make a backup of assets directory and put it in the shared" do
    command "mv #{deploy[:deploy_to]}/current/assets/ #{deploy[:deploy_to]}/current/assets_temp/ && ln -s #{deploy[:deploy_to]}/shared/assets/ #{deploy[:deploy_to]}/current/assets && cp -R #{deploy[:deploy_to]}/current/assets_temp/* #{deploy[:deploy_to]}/current/assets/ && rm -Rf #{deploy[:deploy_to]}/current/assets_temp/"
  end


end

execute "nginx restart" do
  command "/etc/init.d/nginx restart"
end

execute "php5-fpm restart" do
  command "/etc/init.d/php5-fpm restart"
end