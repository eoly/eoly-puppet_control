#!/bin/bash

# install puppetlabs repo
sudo rpm -ivh https://yum.puppetlabs.com/puppetlabs-release-pc1-fedora-24.noarch.rpm

# install puppet-agent
sudo dnf install puppet-agent

# install r10k module
sudo /opt/puppetlabs/bin/puppet module install zack-r10k

# install rubygems rpm
sudo dnf install rubygems

# update sudoers secure path
sudo sed -i '/^Defaults    secure_path/ s;$;:/opt/puppetlabs/bin;' /etc/sudoers