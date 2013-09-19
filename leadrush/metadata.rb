name              "leadrush"
maintainer        "Till Klampaeckel"
maintainer_email  "till@php.net"
license           "BSD License"
description       "Tools we'd like on all servers."
version           "0.1"
recipe            "leadrush::role-nginxapp", "Installs Leadrush Nginx APPS server."

supports 'ubuntu'


depends "nginx-app"
depends "php-fpm"