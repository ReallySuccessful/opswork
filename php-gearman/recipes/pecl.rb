# This recipe is necessary to do a simple `pecl install gearman` on Ubuntu Lucid
include_recipe "php-fpm::source"
php_pear "gearman" do
  version node["gearman"]["pecl"]
  action [ :install, :setup ]
end
