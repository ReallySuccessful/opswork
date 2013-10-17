include_recipe "php-fpm::source"

deps = ["libgearman-dev","php-pear","debconf"]
deps.each do |p|
  package p do
    action :install
  end
end

bash "pecl gearman" do
  user "root"
  cwd "/tmp"
  code <<EOH
  pecl channel-update pecl.php.net
  pear install pecl/gearman
  echo "extension=gearman.so" > /etc/php5/fpm/conf.d/gearman.ini
  echo "extension=gearman.so" > /etc/php5/cli/conf.d/gearman.ini
EOH
end

execute "fpm restart" do
  command "/etc/init.d/php-fpm restart"
end