class profile::elasticsearch {

  include '::profile::java'

  $instances = hiera('elasticsearch_instances')

  class { '::elasticsearch':
    ensure            => present,
    manage_repo       => true,
    repo_version      => '1.4',
    java_install      => false,
    autoupgrade       => false,
    restart_on_change => false,
    status            => 'enabled',
    datadir           => '/var/lib/elasticsearch',
  }
  contain '::elasticsearch'

  elasticsearch::plugin{'elasticsearch/marvel/latest':
    module_dir => 'marvel',
    instances  => keys($::profile::elasticsearch::instances)
  }

  file { '/usr/share/elasticsearch/tmp':
    ensure  => directory,
    mode    => '0770',
    owner   => 'root',
    group   => 'elasticsearch',
    require => Class['::elasticsearch']
  }

  create_resources('elasticsearch::instance',$::profile::elasticsearch::instances)

  Class['::profile::java'] ->
  Class['::elasticsearch']

}
