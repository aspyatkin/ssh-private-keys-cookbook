# ssh-private-keys-cookbook
Chef cookbook to deploy OpenSSH private keys on a system. Data is stored in the encrypted data bag which name is specified in the attribute `node['ssh-private-keys']['data_bag_name']` (by default `ssh-private-keys`). Data bag item name matches `node.chef_environment` value.

## Encrypted data bag format

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

## License
MIT @ [Alexander Pyatkin](https://github.com/aspyatkin)
