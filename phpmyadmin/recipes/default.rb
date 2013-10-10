package "phpmyadmin"

include_recipe "phpmyadmin::configuration"
include_recipe "phpmyadmin::mysql"

include_recipe "phpmyadmin::nginx"