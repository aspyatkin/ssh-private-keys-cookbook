require 'etc'
require 'socket'

module ChefCookbook
  class SSHPrivateKey
    def initialize(node)
      @node = node
      @id = 'ssh-private-keys'
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
      begin
        data_bag_item = ::Chef::EncryptedDataBagItem.load(
          @node[@id]['data_bag_name'],
          @node.chef_environment
        )
      rescue
      end

      ssh_key_map = \
        if data_bag_item.nil?
          {}
        else
          data_bag_item.to_hash.fetch(instance_hostname, {}).fetch(user, {})
        end

      if ssh_key_map.empty?
        ::Chef::Application.fatal!(
          "Couldn't find SSH private keys for <#{user}@#{instance_hostname}> "\
          "in data bag <#{@node[@id]['data_bag_name']}::"\
          "#{@node.chef_environment}>!",
          99
        )
      else
        SSHPrivateKeyEntry.new user, ssh_key_map
      end
    end
  end
end
