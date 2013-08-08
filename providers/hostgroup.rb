action :add do

  if not node['icinga']
      node.normal['icinga'] = {}
  end

  if not node['icinga']['hostgroups']
      node.normal['icinga']['hostgroups'] = []
  end

  new_groups = node['icinga']['hostgroups'].to_set.add(@new_resource.name)
  node.normal['icinga']['hostgroups'] = new_groups.to_a

end

action :remove do
  if not node['icinga']
      node.normal['icinga'] = {}
  end

  if not node['icinga']['hostgroups']
      node.normal['icinga']['hostgroups'] = []
  end

  new_groups = node['icinga']['hostgroups'].to_set.delete(@new_resource.name)
  node.normal['icinga']['hostgroups'] = new_groups.to_a
end
