# this recipe is intended to be used from test-kitchen

user "test"
ssh_private_key "test" do
    source 'chef-vault'
    layout 'simple'
end

user "test2"
ssh_private_key "test2" do
    source 'databag'
    layout 'simple'
end
