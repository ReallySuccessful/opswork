package "supervisor"

template "/etc/supervisor/conf.d/quickfire.conf" do
    source "quickfire.supervisord.conf.erb"
    variables(
      :number_worker         => 1,
      :working_dir             => "/vagrant/"
    )
end


execute "supervisor restart" do
  command "/etc/init.d/supervisor restart"
end