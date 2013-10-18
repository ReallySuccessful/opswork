package "supervisor"

template "/etc/supervisord.conf" do
    source "quickfire.supervisord.conf.erb"
    variables(
      :number_worker         => 1,
      :working_dir             => "/vagrant/"
    )
end

service "supervisor" do
  reload_command "supervisorctl update"
end