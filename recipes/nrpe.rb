package "nagios-nrpe-server"

service "nagios-nrpe-server" do
    supports :restart => true
end

servers = search(:node, "tags:icinga_server AND chef_environment:#{node.chef_environment}").map{ |node|
  node.ipaddress
}

if servers.length == 0 then
  servers = ['127.0.0.1']
end

servers.each do |server|
  AFW.create_rule(node,
                  "Allow NRPE from #{server}",
                   {'table' => 'filter',
                    'rule'  => "-A INPUT -p tcp --dport 5666 -s #{server} -j ACCEPT"
                   })
end

template "/etc/nagios/nrpe.cfg" do
    source "nrpe.cfg.erb"
    variables({
        :icinga_servers => servers
    })
    notifies :restart, resources(:service => "nagios-nrpe-server")
end
