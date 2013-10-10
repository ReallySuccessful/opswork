define :nginx_site, :enable => true, :timing => :delayed do
  if params[:enable]
    execute "nxensite #{params[:name]}" do
      command "/usr/sbin/nxensite #{params[:name]}"
      notifies :reload, 'service[nginx]', params[:timing]
      not_if do
        ::File.symlink?("/etc/nginx/sites-enabled/#{params[:name]}") ||
          ::File.symlink?("/etc/nginx/sites-enabled/000-#{params[:name]}")
      end
    end
  else
    execute "nxdissite #{params[:name]}" do
      command "/usr/sbin/nxdissite #{params[:name]}"
      notifies :reload, 'service[nginx]', params[:timing]
      only_if do
        ::File.symlink?("/etc/nginx/sites-enabled/#{params[:name]}") ||
          ::File.symlink?("/etc/nginx/sites-enabled/000-#{params[:name]}")
      end
    end
  end
end