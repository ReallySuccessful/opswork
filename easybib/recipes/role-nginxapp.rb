# Default App

include_recipe "easybib::setup"
include_recipe "nginx-app::server"
include_recipe "php-fpm"