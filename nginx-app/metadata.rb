name              "nginx-app"
maintainer        "David Lemarier"
maintainer_email  "david@reallysuccessful.com"
license           "BSD License"
description       "Installs and configures an nginx for our appservers."
version           "0.1"
recipe            "nginx-app::server", "Installs Nginx"

depends "php-fpm"
depends "apt"

%w{ ubuntu debian }.each do |os|
  supports os
end
