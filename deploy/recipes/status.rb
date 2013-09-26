include_recipe "php-fpm::service"

instance_layer = node["opsworks"]["instance"]["layers"]

all_results = {}

node[:deploy].each do |application, deploy_data|

	app_role = deploy_data[:deploy_layer]

	if !instance_layer.include?("develop")
	    if !instance_layer.include?(app_role)
	        next
	    end

	    deploy_domains = deploy_data[:domains]
	    deploy_branch = "master"

  	else

	    deploy_domains= deploy_data[:beta_domains]
	    deploy_branch = "develop"

  	end  

	find = Mixlib::ShellOut.new("cd /srv/www/#{application}/current && git describe --tags")
    find.run_command    
    tag = find.stdout
    find = Mixlib::ShellOut.new("cd /srv/www/#{application}/current && git log --oneline -1")
    find.run_command    
    last_commit = find.stdout

	all_results[application] = {
	    "running_version" => tag,
		"last_commit" => last_commit,
		"branch" => deploy_branch,
		"domains" => deploy_domains
	}

end	

message_to_send = { 
	:applications => all_results, 
	:server_details => {
	    "hostname" => node[:opsworks][:instance][:hostname],
	    "instance_id" => node[:opsworks][:instance][:id],
	    "instance_type" => node[:opsworks][:instance][:instance_type],
	    "public_ip" => node[:opsworks][:instance][:ip],
	    "layer" => instance_layer
	} 
}

# send post to MAMA
http_request "Alerting mama !" do
	action :post
	url "http://mamabot.herokuapp.com/webhook/dev"
	message message_to_send
end	