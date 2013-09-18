define :ci_web_app, :template => "site.erb", :enable => true do
  include_recipe "nginx::service"

  application = params[:application]
  application_name = params[:name]

  template "#{node['nginx-app']['config_dir']}/sites-enabled/#{application_name}.conf" do
    Chef::Log.debug("Generating Nginx site template for #{application_name.inspect}")
    source params[:template]
    owner "root"
    group "root"
    mode 0644
    if params[:cookbook]
      cookbook params[:cookbook]
    end
    variables(
      :application => application,
      :application_name => application_name,
      :params => params
    )
    if File.exists?("#{node['nginx-app']['config_dir']}/sites-enabled/#{application_name}.conf")
      notifies :reload, "service[nginx]", :delayed
    end
  end

  directory "#{node['nginx-app']['config_dir']}/ssl" do
    action :create
    owner "root"
    group "root"
    mode 0600
  end

  template "#{node['nginx-app']['config_dir']}/ssl/#{application[:domains].first}.crt" do
    cookbook 'nginx'
    mode '0600'
    source "ssl.key.erb"
    variables :key => application[:ssl_certificate]
    notifies :restart, "service[nginx]"
    only_if do
      application[:ssl_support]
    end
  end

  template "#{node['nginx-app']['config_dir']}/ssl/#{application[:domains].first}.key" do
    cookbook 'nginx'
    mode '0600'
    source "ssl.key.erb"
    variables :key => application[:ssl_certificate_key]
    notifies :restart, "service[nginx]"
    only_if do
      application[:ssl_support]
    end
  end

  template "#{node['nginx-app']['config_dir']}/ssl/#{application[:domains].first}.ca" do
    cookbook 'nginx'
    mode '0600'
    source "ssl.key.erb"
    variables :key => application[:ssl_certificate_ca]
    notifies :restart, "service[nginx]"
    only_if do
      application[:ssl_support] && application[:ssl_certificate_ca]
    end
  end

  file "#{node['nginx-app']['config_dir']}/sites-enabled/default" do
    action :delete
    only_if do
      File.exists?("#{node['nginx-app']['config_dir']}/sites-enabled/default")
    end
  end

  if params[:enable]
    execute "nxensite #{application_name}" do
      command "/usr/sbin/nxensite #{application_name}"
      notifies :reload, "service[nginx]"
      not_if do File.symlink?("#{node['nginx-app']['config_dir']}/sites-enabled/#{application_name}.conf") end
    end
  else
    execute "nxdissite #{application_name}" do
      command "/usr/sbin/nxdissite #{application_name}"
      notifies :reload, "service[nginx]"
      only_if do File.symlink?("#{node['nginx-app']['config_dir']}/sites-enabled/#{application_name}.conf") end
    end
  end
end
