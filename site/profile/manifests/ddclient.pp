class profile::ddclient {

 $packages = [ 'perl-JSON','perl-JSON-Any','perl-IO-Socket-SSL' ]

 $source_url  = "https://github.com/wimpunk/ddclient/archive/master.zip"
 $target_dir  = '/opt/staging'
 $target_file = 'ddclient.zip'
 $target      = "$::profile::ddclient::download_dir/$::profile::ddclient::file_name"
 $extracted     = "$::profile::ddclient::target_dir/ddclient-master"
 $config_source = "$::profile::ddclient::extracted/sample-etc_ddclient.conf"
 $init_source   = "$::profile::ddclient::extracted/sample-etc_rc.d_init.d_ddclient.redhat"

 $cloudflare_zone   = hiera('cloudflare_zone')
 $cloudflare_login  = hiera('cloudflare_login')
 $cloudflare_apikey = hiera('cloudflare_apikey')
 $cloudflare_record = hiera('cloudflare_record')

 package { $::profile::ddclient::packages:
   ensure => present
 }

 File {
   owner  => 'root',
   group  => 'root',
 }

 file { '/var/cache/ddclient':
   ensure => directory,
   mode   => '0755',
 }

 file { '/etc/ddclient':
   ensure => directory,
   mode   => '0755',
 } ->

 file { '/etc/ddclient/ddclient.conf':
   ensure  => present,
   mode    => '0600',
   content => template("${module_name}/ddclient.conf.erb"),
 }

 staging::file { $::profile::ddclient::target_file:
   source => $::profile::ddclient::source_url,
   target => $::profile::ddclient::target,
 }

 staging::extract { $::profile::ddclient::target_file:
   source  => $::profile::ddclient::target,
   target  => $::profile::ddclient::target_dir,
   creates => $::profile::ddclient::extracted,
   require => Staging::File[$::profile::ddclient::target_file],
 }

 exec { 'install_ddclient':
   command => "/bin/cp $::profile::ddclient::extracted/ddclient /usr/local/sbin/ddclient",
   require => Staging::Extract[$::profile::ddclient::target_file],
 }

 exec { 'install_init':
   command => "/bin/cp $::profile::ddclient::init_source /etc/init.d/ddclient",
   require => Staging::Extract[$::profile::ddclient::target_file],
 }

}
