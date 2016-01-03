class profile::logstash {

  $logstash_redis_server  = "redis.hq.sourcecurrent.net"
  $logstash_redis_key     = "logstash"
 
  include '::profile::java'

  class { '::logstash':
    ensure            => present,
    status            => 'enabled',
    manage_repo       => true,
    repo_version      => '1.4',
    java_install      => false,
    autoupgrade       => false,
    restart_on_change => false,
  }

  logstash::configfile { 'output_redis':
    content => template("${module_name}/logstash/output_redis.conf.erb"),
    order => 30
  }

}
