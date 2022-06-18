provides :ssh_private_key

resource_name :ssh_private_key

property :user, String, name_property: true
property :source, String, default: node['ssh-private-keys']['default_source']
property :bag, String, default: node['ssh-private-keys']['data_bag_name']
property :layout, String, default: node['ssh-private-keys']['data_bag_layout']

default_action :deploy

action :deploy do

  if new_resource.source == 'chef-vault'
    chef_gem "chef-vault" do
      compile_time true
    end
  end

  helper = ::ChefCookbook::SSHPrivateKey.new(node, new_resource.source, new_resource.bag, new_resource.layout)

  actual_item = helper.ssh_private_key_entry new_resource.user

  directory actual_item.ssh_dir do
    owner actual_item.user
    group actual_item.group
    mode 0700
    recursive true
    action :create
  end

  actual_item.ssh_key_map.each do |key_type, key_content|
    file_name = ::File.join actual_item.ssh_dir, key_type

    file file_name do
      owner actual_item.user
      group actual_item.group
      mode 0600
      sensitive true
      content key_content
      action :create
    end
  end
end

# vim: set ts=2 softtabstop=2 shiftwidth=2 expandtab:
