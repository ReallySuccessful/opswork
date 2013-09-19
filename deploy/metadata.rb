name              "deploy"
maintainer        "David Lemarier"
maintainer_email  "david@reallysuccessful.com"
license           "BSD License"
description       "Deploys Leadrush APP"
version           "0.1"
recipe            "deploy::codeigniter", "Deploys CI c0dez!!!"

supports 'ubuntu'

depends "php-fpm"
depends "nginx-app"