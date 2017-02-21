# ssh-private-keys-cookbook
Chef cookbook to deploy OpenSSH private keys on a system. Data is stored in the encrypted data bag or chef-vault which name is specified in the attribute `node['ssh-private-keys']['data_bag_name']` (by default `ssh-private-keys`). Data bag may have two layouts: simple and andvanced. In simple layout bag item name contains the name of the user which key you're want to deploy. Advanced layout is more complex and should match the `node.chef_environment` value.

## Simple data bag format

``` json
{
    "id": "admin1",
    "id_rsa": ""
}
```

## Advanced data bag format

``` json
{
  "id": "development",
  "server1.acme.corp": {
    "admin1": {
      "id_rsa": "",
    }
  },
  "server2.acme.corp": {
    "admin2": {
      "id_ed25519": ""
    }
  }
}
```

## Resources

### ssh_private_key

Keys deployment is made by using `ssh_private_key` resource. For example,

``` ruby
ssh_private_key 'admin1'
```

Server hostname will be automatically detected and the appropriate record will be retrieved from the encrypted data bag. All keys in the specified record (e.g. RSA, Ed25519) will be placed under user's SSH directory (`/home/username/.ssh`).

## Attributes

* `default['ssh-private-keys']['default_source']` - Specify 'databag' or 'chef-vault'
* `default['ssh-private-keys']['data_bag_name']` - Bag name or vault name to load ssh keys from
* `default['ssh-private-keys']['data_bag_layout']['advanced']` - Specify databag layout type. May be 'true' or 'false'


## License
MIT @ [Alexander Pyatkin](https://github.com/aspyatkin)
