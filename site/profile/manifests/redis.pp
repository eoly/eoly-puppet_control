class profile::redis {

  class { '::redis::install':
    redis_version => present,
    redis_package => true,
  }
  contain '::redis::install'

  redis::server { 'logstash':
    redis_memory => '1g',
    redis_ip     => '0.0.0.0',
    redis_port   => 6379,
    running      => true,
  }

  redis::server { 'test':
    redis_memory => '1g',
    redis_ip     => '0.0.0.0',
    redis_port   => 6380,
    running      => false,
    enabled      => false,
  }
  
}
