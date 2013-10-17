include_recipe "php-fpm::source"

bash "pecl gearman" do
  user "root"
  cwd "/tmp"
  code <<EOH
  pecl channel-update pecl.php.net
  pear install pecl/gearman
  echo "extension=gearman.so" > /etc/php5/fpm/gearman.ini
  echo "extension=gearman.so" > /etc/php5/cli/gearman.ini
EOH
end