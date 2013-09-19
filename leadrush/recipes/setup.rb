base_packages = [
  "htop", "jwhois", "multitail",
   "strace", "rsync",
  "manpages", "manpages-dev", "nscd",
  "subversion", "git-core", "unzip"
]

base_packages.each do |p|
  package p
end

package "landscape-client" do
  action :purge
end

["ganglia-monitor", "libganglia1"].each do |p|
  package p do
    action :purge
  end
end
