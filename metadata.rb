name 'ssh-private-keys'
maintainer 'Aleksandr Piatkin'
maintainer_email 'oss@aptkn.ch'
license 'MIT'
description 'Deploy OpenSSH private keys'
long_description ::IO.read(::File.join(::File.dirname(__FILE__), 'README.md'))
version '2.0.2'

scm_url = 'https://github.com/aspyatkin/ssh-private-keys-cookbook'
source_url scm_url if respond_to?(:source_url)
issues_url "#{scm_url}/issues" if respond_to?(:issues_url)

supports 'ubuntu'
