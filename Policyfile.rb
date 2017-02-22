# Policyfile.rb - Describe how you want Chef to build your system.
#
# For more information on the Policyfile feature, visit
# https://docs.chef.io/policyfile.html

# A name that describes what the system you're building with Chef does.
name "example-ssh-private-keys"

# Where to find external cookbooks:
default_source :supermarket

# run_list: chef-client will run these recipes in the order specified.
#run_list "ssh-private-keys::default"
run_list "ssh-private-keys"
named_run_list :testing, "ssh-private-keys::test"

# Specify a custom source for a single cookbook:
# cookbook "example_cookbook", path: "../cookbooks/example_cookbook"
cookbook "ssh-private-keys", path: "../ssh-private-keys"
