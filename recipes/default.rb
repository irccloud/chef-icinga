#
# Cookbook Name:: icinga
# Recipe:: default

package "icinga"

service "icinga" do
    supports :restart => true, :reload => true
end

hostgroups = Set.new(['servers'])

nodes = search(:node, node[:icinga][:node_query])

if nodes.empty?
  # If there are no nodes (e.g. in testing), add localhost as Icinga
  # doesn't like hostgroups with no nodes in.
  nodes = [node]
end

nodes = nodes.map { |n|
  data = {:name => n[:fqdn], :address => n[:ipaddress], :groups => ['servers'] }

  if n[:icinga] and n[:icinga][:address]
    data[:address] = n[:icinga][:address]
  end

  if n[:icinga] and n[:icinga][:hostgroups]
    data[:groups] += n[:icinga][:hostgroups]
    hostgroups.merge(n[:icinga][:hostgroups])
  end

  data
}.sort_by { |data| data[:address] }

tag('icinga_server')

template "/etc/icinga/objects/hosts.cfg" do
  source "nodes.cfg"
  mode "0644"
  variables(:nodes => nodes)
  notifies :reload, resources(:service => "icinga")
end

template "/etc/icinga/objects/hostgroups.cfg" do
  source "hostgroups.cfg"
  mode "0644"
  variables(:groups => hostgroups.sort)
  notifies :reload, resources(:service => "icinga")
end


['localhost_icinga.cfg', 'hostgroups_icinga.cfg', 'services_icinga.cfg', 'extinfo_icinga.cfg'].each do | filename | 
  file "/etc/icinga/objects/#{filename}" do
    action :delete
    notifies :reload, resources(:service => "icinga")
  end
end
