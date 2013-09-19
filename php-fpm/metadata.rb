name              "php-fpm"
maintainer        "David Lemarier"
maintainer_email  "david@reallysuccessful.com"
license           "PHP License"
description       "Installs and configures PHP FPM for nginx."
version           "0.1"
recipe            "php-fpm::default", "Install PHP FPM"

supports 'ubuntu'