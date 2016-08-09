class profile::packer {
  $version = '0.10.1'

  class { 'packer':
    version  => $version,
    base_url => "https://releases.hashicorp.com/packer/"
  }
}
