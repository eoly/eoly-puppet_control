class profile::postfix {

  $myhostname             = hiera('postfix_myhostname')
  $mydomain               = hiera('postfix_mydomain')
  $mydestination          = hiera('postfix_mydestination')
  $inet_interfaces        = hiera('postfix_inet_interfaces')
  $mail_name              = hiera('postfix_mail_name')
  $mynetworks             = hiera('postfix_mynetworks')
  $virtual_alias_domains  = hiera('postfix_virtual_alias_domains')
  $virtual_alias_maps     = hiera('postfix_virtual_alias_maps')
  $postfix_virtual        = hiera('postfix_virtual')

  class { '::postfix::server':
    myhostname            => $myhostname,
    mydomain              => $mydomain,
    mydestination         => $mydestination,
    inet_interfaces       => $inet_interfaces,
    mail_name             => $mail_name,
    mynetworks            => $mynetworks,
    virtual_alias_domains => $virtual_alias_domains,
    virtual_alias_maps    => $virtual_alias_maps,
  }

  postfix::dbfile { 'virtual':
    content => template('profile/postfix_virtual.erb'),
  }
  
}
