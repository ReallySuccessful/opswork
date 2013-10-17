# make sure php-gearman::pecl is ran before this cookbook
deps = ["gearman"]
deps.each do |p|
  package p do
    action :install
  end
end

# we need to setup supervisord