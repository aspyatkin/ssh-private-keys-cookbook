# source for ssh private key
#default['ssh-private-keys']['default_source'] = 'chef-vault'
default['ssh-private-keys']['default_source'] = 'databag'

# name of the vault or data bag
default['ssh-private-keys']['data_bag_name'] = 'ssh-private-keys'

# In case chef-vault failed to access the vault data try to handle it as unencrypted databag.
# This mostly needed for testing cookbook in kitchen environment
default['chef-vault']['databag_fallback'] = true

# use advanced databag layout with nodes and environments
default['ssh-private-keys']['data_bag_layout']['advanced'] = true
