class profile::postfix {

  $myhostname                 = hiera('postfix_myhostname')
  $mydomain                   = hiera('postfix_mydomain')
  $mydestination              = hiera('postfix_mydestination')
  $inet_interfaces            = hiera('postfix_inet_interfaces')
  $mail_name                  = hiera('postfix_mail_name')
  $mynetworks                 = hiera('postfix_mynetworks')
  $virtual_mailbox_domains    = hiera('postfix_virtual_mailbox_domains')
  $virtual_mailbox_maps       = hiera('postfix_virtual_alias_maps')
  $postfix_virtual_mailboxes  = hiera('postfix_virtual_aliases')
  $virtual_alias_domains      = hiera('postfix_virtual_alias_domains')
  $virtual_alias_maps         = hiera('postfix_virtual_alias_maps')
  $postfix_virtual_aliases    = hiera('postfix_virtual_aliases')

  class { '::postfix::server':
    myhostname              => $myhostname,
    mydomain                => $mydomain,
    mydestination           => $mydestination,
    inet_interfaces         => $inet_interfaces,
    mail_name               => $mail_name,
    mynetworks              => $mynetworks,
    virtual_mailbox_domains => $virtual_mailbox_domains,
    virtual_mailbox_maps    => $virtual_mailbox_maps,
    virtual_mailbox_base    => '/var/spool/mail/vhosts',
    virtual_uid_maps        => 'static:5000',
    virtual_gid_maps        => 'static:5000',
    virtual_alias_domains   => $virtual_alias_domains,
    virtual_alias_maps      => $virtual_alias_maps,
  }

  postfix::dbfile { 'virtual':
    content => template('profile/postfix_virtual_aliases.erb'),
  }

  postfix::dbfile { 'vmailbox':
    content => template('profile/postfix_virtual_mailboxes.erb'),
  }
  
}
