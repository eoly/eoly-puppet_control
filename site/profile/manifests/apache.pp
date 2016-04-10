class profile::apache {

  class { '::apache': 
    default_vhost          => false,
    server_tokens          => 'ProductOnly',
    server_signature       => 'Off',
    serveradmin            => 'webmaster@ericolsen.net',
    server_root            => '/etc/httpd',
    keepalive              => 'On',
    max_keepalive_requests => '500',
    keepalive_timeout      => '15',
    mpm_module             => false,
    trace_enable           => 'Off',
    vhost_dir              => '/etc/httpd/vhosts.d',
    purge_vhost_dir        => false,
  }
  
  class { '::apache::mod::prefork':
    startservers        => '8',
    minspareservers     => '5',
    maxspareservers     => '20',
    maxclients          => '100',
    maxrequestsperchild => '1000',
  }

  class { '::apache::mod::status':
    allow_from      => [ '127.0.0.1' ],
    extended_status => 'On',
  }

  ::apache::vhost { 'ericolsen.net':
    port              => '80',
    ip_based          => false,
    serveraliases     => [ 'www.ericolsen.net' ],
    access_log_format => 'combined',
    docroot           => '/var/www/www.ericolsen.net',
    docroot_group     => 'webdev',
    docroot_mode      => '0775',
    directories       => [
      {
        path           => '/var/www/www.ericolsen.net',
        options        => [ '-Indexes','+FollowSymLinks','+MultiViews' ],
        order          => 'Allow,Deny',
        allow_override => 'None',
      }
    ],
  }

  if $::osfamily == 'RedHat' and $::architecture == 'x86_64' {

    case $::operatingsystemmajrelease {
      '7':  { 
        $mod_cloudflare_url = 'http://copr-be.cloud.fedoraproject.org/results/codeblock/mod_cloudflare/epel-7-x86_64/mod_cloudflare-1.0.3-0.1.20141106gitda8436d.fc21/mod_cloudflare-1.0.3-0.1.20141106gitda8436d.el7.centos.x86_64.rpm'
      }
      '6': {
        $mod_cloudflare_url = 'https://www.cloudflare.com/static/misc/mod_cloudflare/centos/mod_cloudflare-el6-x86_64.latest.rpm'
      }
      default: { $mod_cloudflare_url = undef }
    }

    if $::profile::apache::mod_cloudflare_url {
      ::wget::fetch { 'mod_cloudflare_rpm':
        source      => $::profile::apache::mod_cloudflare_url,
        destination => '/tmp/mod_cloudflare.rpm',
        require     => Class['::apache'],
      }

      package { 'mod_cloudflare':
        provider => 'rpm',
        ensure   => present,
        source   => '/tmp/mod_cloudflare.rpm',
        require  => Wget::Fetch['mod_cloudflare_rpm'],
      }

      file { '/etc/httpd/conf.d/cloudflare.conf':
        ensure  => present,
        mode    => '0644',
        owner   => 'root',
        group   => 'root',
        content => 'LoadModule cloudflare_module modules/mod_cloudflare.so',
        require => Package['mod_cloudflare'],
        notify  => Service['httpd'],
      }
    }

  }

}
