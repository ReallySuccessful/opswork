include_recipe "php-fpm::service"

node[:deploy].each do |application, deploy|
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

execute "php5-fpm restart" do
  command "/etc/init.d/php5-fpm restart"
end