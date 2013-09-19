include_recipe "php-fpm::prepare"

if !node["php-fpm"]["packages"].empty?
  apt_packages = node["php-fpm"]["packages"].split(',')

  apt_packages.each do |p|
    package p do
      action :install
    end
  end
end

include_recipe "php-fpm::configure"