require 'etc'
require 'socket'
require 'chef/resource'

module ChefCookbook
  class SSHPrivateKey
    def initialize(node, source, bag, layout)
      @node = node
      @source = source
      @bag = bag
      @layout = layout
    end

    class SSHPrivateKeyEntry
      def initialize(user, ssh_key_map)
        @_user = user
        @_ssh_key_map = ssh_key_map
      end

      def user
        @_user
      end

      def group
        ::Etc.getgrgid(::Etc.getpwnam(user).gid).name
      end

      def home_dir
        ::Etc.getpwnam(user).dir
      end

      def ssh_dir
        ::File.join home_dir, '.ssh'
      end

      def ssh_key_map
        @_ssh_key_map
      end
    end

    def instance_hostname
      ::Socket.gethostname
    end

    def ssh_private_key_entry(user)
      data_bag_item = nil
      if @source == 'chef-vault'
        require 'chef-vault'
        if @layout == 'advanced'
          if ChefVault::Item.vault?(@bag, @node.chef_environment)
            data_bag_item = ChefVault::Item.load(@bag, @node.chef_environment)
          elsif @node['chef-vault']['databag_fallback']
            data_bag_item = Chef::DataBagItem.load(@bag, @node.chef_environment)
          else
            raise "Failed to load data bag item <#{@node.chef_environment}> from <#{@bag}>"
          end

        else
          if ChefVault::Item.vault?(@bag, user)
            data_bag_item = ChefVault::Item.load(@bag, user)
          elsif @node['chef-vault']['databag_fallback']
            data_bag_item = Chef::DataBagItem.load(@bag, user)
          else
            raise "Failed to load data bag item <#{user}> from <#{@bag}>"
          end
        end
      elsif @source == 'databag'
        if @layout == 'advanced'
          begin
            data_bag_item = ::Chef::EncryptedDataBagItem.load(
              @bag,
              @node.chef_environment
            )
          rescue
          end
        else
          begin
            data_bag_item = Chef::EncryptedDataBagItem.load(@bag, user)
          rescue
          end
        end
      end

      ssh_key_map = \
        if data_bag_item.nil?
          {}
        else
          if @layout == 'advanced'
            data_bag_item.to_hash.fetch(instance_hostname, {}).fetch(user, {})
          else
            data_bag_item.to_hash.fetch('keys', {})
          end
        end

      if ssh_key_map.empty?
        if @layout == 'advanced'
          Chef::Application.fatal!(
            "Couldn't find SSH private keys for <#{user}@#{instance_hostname}> "\
            "in data bag <#{@node[@id]['data_bag_name']}::"\
            "#{@node.chef_environment}>!",
            99
          )
        else
          Chef::Application.fatal!(
            "Couldn't find SSH private keys for <#{user}> "\
            "in data bag <#{@bag}>",
            99
          )
        end
      else
        SSHPrivateKeyEntry.new user, ssh_key_map
      end
    end
  end
end

# vim: set ts=2 softtabstop=2 shiftwidth=2 expandtab:
