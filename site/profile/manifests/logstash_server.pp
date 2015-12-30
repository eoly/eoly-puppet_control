class profile::logstash_server {

  $logstash_redis_server  = "localhost"
  $logstash_redis_key     = "logstash"
  $logstash_es_server     = "localhost"
  $logstash_es_cluster    = "logstash"
 
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

  logstash::configfile { 'input_redis':
    content => template("${module_name}/logstash/input_redis.conf.erb"),
    order => 10
  }

  logstash::configfile { 'filter_apache':
    content => template("${module_name}/logstash/filter_apache.conf.erb"),
    order => 20
  }

  logstash::configfile { 'output_es':
    content => template("${module_name}/logstash/output_es.conf.erb"),
    order => 30
  }

}
