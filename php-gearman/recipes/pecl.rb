include_recipe "php-fpm::source"

# app ppa
ppa "gearman-developers/ppa"

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
  pear install pecl/gearman-1.1.1
  pear install pear/Net_Gearman-0.2.3
  echo "extension=gearman.so" > /etc/php5/conf.d/gearman.ini
EOH
end

execute "fpm restart" do
  command "/etc/init.d/php-fpm restart"
end