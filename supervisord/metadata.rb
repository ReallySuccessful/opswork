name              "supervisord"
maintainer        "David Lemarier"
maintainer_email  "david@reallysuccessful.com"
license           "PHP License"
description       "Installs and configures Supervisord for gearman workers."
version           "0.1"
recipe            "supervisord::qfs", "Installs QFS workers"

supports "ubuntu"