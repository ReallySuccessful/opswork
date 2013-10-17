name              "php-gearman"
maintainer        "David Lemarier"
maintainer_email  "david@reallysuccessful.com"
license           "PHP License"
description       "Installs and configures PHP FPM for nginx."
version           "0.1"
recipe            "php-gearman::pecl", "Installs php-gearman from PECL."
recipe            "php-gearman::server", "Installs gearman server from PECL."

depends "php-fpm"
depends "php"
depends "apt"
depends "apt-repo"

supports 'ubuntu'
