name              "leadrush"
maintainer        "David Lemarier"
maintainer_email  "david@reallysuccessful.com"
license           "BSD License"
description       "Tools we'd like on all servers."
version           "0.1"
recipe            "leadrush::role-nginxapp", "Installs Leadrush Nginx APPS server."

supports 'ubuntu'


depends "nginx-app"
depends "php-fpm"