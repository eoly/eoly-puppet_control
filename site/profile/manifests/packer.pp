class profile::packer {
  class { 'packer':
    version  => '0.8.6',
    base_url => 'https://releases.hashicorp.com/packer'
  }
}
