# Default App

include_recipe "leadrush::setup"
include_recipe "nginx-app::server"
include_recipe "php-fpm"