class profile::packer {
  $version = '0.8.6'

  class { 'packer':
    version  => $version,
    base_url => "https://releases.hashicorp.com/packer/${version}/"
  }
}
