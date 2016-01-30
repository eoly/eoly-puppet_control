class profile::elk {

  # This stuff needs lots of Java
  include '::profile::java'

  # Get cluster_dns_name
  $dns_name = hiera("profiles::elk::dns_name")

  # Build array of nginx es members
  $nginx_es_members = [ 'localhost:9200' ]

  # Build array of nginx kibana members
  $nginx_kibana_members = [ 'localhost:5601' ]

  class { '::nginx': }

  nginx::resource::upstream { 'nginx_es_members':
    members              => $nginx_es_members,
    upstream_cfg_prepend => {
      'keepalive'        => '15',
    }
  }

  nginx::resource::vhost { "${dns_name}_es":
    server_name      => [ $dns_name ],
    ssl              => false,
    listen_port      => 8080,
    proxy            => 'http://nginx_es_members',
    proxy_set_header => [
      'Connection "Keep-Alive"',
      'Proxy-Connection "Keep-Alive"'
    ]
  }

  nginx::resource::upstream { 'nginx_kibana_members':
    members => $nginx_kibana_members,
    upstream_cfg_prepend => {
      'ip_hash'          => '',
      'keepalive'        => '15',
    }
  }

  nginx::resource::vhost { $dns_name:
    server_name   => [ $dns_name ],
    ssl           => false,
    listen_port   => 80,
    www_root      => "/var/www/${dns_name}",
  }

  nginx::resource::location { "${dns_name}_kibana":
    ensure   => present,
    ssl      => true,
    ssl_only => true,
    location => '/kibana/',
    vhost    => $dns_name,
    proxy    => 'http://nginx_kibana_members/',
  }

  ## Kibana Config Section
  class { '::kibana':
    es_url => 'http://localhost:8080',
  }

  ## Redis Config Section
  class { '::redis':
    activerehashing => true,
    bind            => '0.0.0.0'
  }

  ## Elasticsearch Config Section

  # Move tmp to avoid CIS hardening restrictions
  $es_tmp_dir = '/usr/share/elasticsearch/tmp'

  # Calculate Elasticsearch Heap Size (uses half of system memory)
  $es_heap_size_mb = inline_template('<%= (memorysize_mb.to_i/2).floor -%>')

  class { '::elasticsearch':
    ensure            => present,
    autoupgrade       => false,
    status            => 'running',
    restart_on_change => false,
    purge_configdir   => true,
    java_install      => false,
    manage_repo       => true,
    repo_version      => '1.7',
    datadir           => '/var/lib/elasticsearch/data',
  }

  elasticsearch::instance { 'es01':
    init_defaults        => {
      'ES_HEAP_SIZE'      => "${es_heap_size_mb}m",
      'MAX_LOCKED_MEMORY' => 'unlimited',
      'MAX_OPEN_FILES'    => '131070',
      'ES_JAVA_OPTS'      => '"-Djna.tmpdir=/usr/share/elasticsearch/tmp -Djava.io.tmpdir=/usr/share/elasticsearch/tmp"'
    },
    config                                                      => {
      'node.name'                                               => $::fqdn,
      'node.master'                                             => true,
      'node.data'                                               => true,
      'bootstrap.mlockall'                                      => true,
      'action.disable_delete_all_indices'                       => true,
      'gateway.recover_after_nodes'                             => 1,
      'gateway.expected_nodes'                                  => 1,
      'gateway.recover_after_time'                              => '5m',
      'cluster.name'                                            => 'elk',
      'cluster.routing.allocation.cluster_concurrent_rebalance' => '2',
      'cluster.routing.allocation.disk.watermark.high'          => '90%',
      'cluster.routing.allocation.disk.watermark.low'           => '85%',
      'indicies.fielddata.cache.size'                           => '40%',
      'indicies.recovery.concurrent_streams'                    => '4',
      'index.number_of_shards'                                  => '4',
      'index.number_of_replicas'                                => '1',
      'discovery.zen.ping_timeout'                              => '3s',
      'discovery.zen.ping.multicast.enabled'                    => false,
      'discovery.zen.ping.unicast.hosts'                        => ['localhost'],
      'discovery.zen.minimum_master_nodes'                      => 1,
      'discovery.zen.fd.ping_interval'                          => '1s',
      'discovery.zen.fd.ping_timeout'                           => '30s',
      'discovery.zen.fd.ping_retries'                           => '3',
      'http.cors.enabled'                                       => true,
      'http.cors.allow-origin'                                  => '"*"',
    }
  }

  file { '/usr/share/elasticsearch/tmp':
    ensure  => directory,
    mode    => '0770',
    owner   => 'root',
    group   => 'elasticsearch',
    require => Class['::elasticsearch']
  }

  ## Logstash Config Section

  # Calculate Logstash Heap Size (uses 20% of system memory)
  $ls_heap_size_mb = inline_template('<%= (memorysize_mb.to_i/5).floor -%>')

  class { '::logstash':
    ensure            => present,
    autoupgrade       => false,
    status            => 'running',
    version           => '1.5.4-1',
    restart_on_change => false,
    purge_configdir   => true,
    java_install      => false,
    manage_repo       => true,
    repo_version      => '1.5',
    init_defaults     => {
      'LS_HEAP_SIZE'  => "${ls_heap_size_mb}m"
    }
  }

  # rotate /var/log/logstash logs, restart logstash process
  logrotate::rule { 'logstash':
    path          => '/var/log/logstash/*.log',
    rotate        => 7,
    rotate_every  => 'day',
    copytruncate  => true,
    compress      => true,
    delaycompress => true,
    missingok     => true,
    postrotate    => 'systemctl restart logstash'
  }

}
