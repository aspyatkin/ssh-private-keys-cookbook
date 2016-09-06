resource_name :ssh_private_key

property :user, String, name_property: true

default_action :deploy

action :deploy do
  helper = ::ChefCookbook::SSHPrivateKey.new node

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
