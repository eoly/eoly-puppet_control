class profile::base {

  include ::epel

  $ntp_servers = hiera('ntp_servers')
  $user_groups = hiera('user_groups')

  validate_array($::profile::base::ntp_servers)
  validate_hash($::profile::base::user_groups)

  class { 'ntp':
    servers => $::profile::base::ntp_servers,
  }

  package { 'vim': ensure => present }

  create_resources(group,$::profile::base::user_groups)

}
