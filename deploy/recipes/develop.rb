include_recipe "php-fpm::service"

all_results = {}

node[:deploy].each do |application, deploy_data|
  
  deploy_domains = deploy_data[:domains]
  deploy_branch = "develop"

  ci_deploy_dir do
    user deploy_data[:user]
    group deploy_data[:group]
    path deploy_data[:deploy_to]
  end

  ci_web_app application do
    application deploy_data
    deploy_domains deploy_domains
    cookbook "nginx-app"
    environment "development"
  end

  # dump mysql data
  execute "mysqldump" do
    command  "mysql -uroot -pleadrush < " + deploy_data[:deploy_to] + "/" + deploy_data[:db_file]
  end

end

execute "nginx restart" do
  command "/etc/init.d/nginx restart"
end

execute "fpm restart" do
  command "/etc/init.d/php-fpm restart"
end