name 'ssh-private-keys'
maintainer 'Alexander Pyatkin'
maintainer_email 'aspyatkin@gmail.com'
license 'MIT'
description 'Deploy OpenSSH private keys'
long_description ::IO.read(::File.join(::File.dirname(__FILE__), 'README.md'))
version '2.0.1'

scm_url = 'https://github.com/aspyatkin/ssh-private-keys-cookbook'
source_url scm_url if respond_to?(:source_url)
issues_url "#{scm_url}/issues" if respond_to?(:issues_url)

supports 'ubuntu'
