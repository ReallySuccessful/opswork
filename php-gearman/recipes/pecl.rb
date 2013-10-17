# This recipe is necessary to do a simple `pecl install gearman` on Ubuntu Lucid
include_recipe "php-fpm::source"

deps = ["libgearman-dev","php-pear"]
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
  echo "extension=gearman.so" > /etc/php5/fpm/gearman.ini
  echo "extension=gearman.so" > /etc/php5/cli/gearman.ini
EOH
end