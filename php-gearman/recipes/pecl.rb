# This recipe is necessary to do a simple `pecl install gearman` on Ubuntu Lucid
php_pear "gearman" do
  version node["gearman"]["pecl"]
  action [ :install, :setup ]
end
