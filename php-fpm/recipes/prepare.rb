# little fix to create symbolic name for php5-fpm service name
execute "fix php-fpm service name" do
  command "rm -Rf /etc/init.d/php-fpm && ln -s /etc/init.d/php5-fpm /etc/init.d/php-fpm"
end

directory node["php-fpm"]["tmpdir"] do
  mode "0755"
  owner node["php-fpm"]["user"]
  group node["php-fpm"]["group"]
end

directory File.dirname(node["php-fpm"]["logfile"]) do
  mode "0755"
  owner node["php-fpm"]["user"]
  group node["php-fpm"]["group"]
end

file node["php-fpm"]["logfile"] do
  mode "0755"
  owner node["php-fpm"]["user"]
  group node["php-fpm"]["group"]
end

file node["php-fpm"]["slowlog"] do
  mode "0755"
  owner node["php-fpm"]["user"]
  group node["php-fpm"]["group"]
end

file node["php-fpm"]["fpmlog"] do
  mode "0755"
  owner node["php-fpm"]["user"]
  group node["php-fpm"]["group"]
end

directory node["php-fpm"]["socketdir"] do
  mode "0755"
  owner node["php-fpm"]["user"]
  group node["php-fpm"]["group"]
end

