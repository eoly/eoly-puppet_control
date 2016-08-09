class profile::hipchat {
  yumrepo { 'hipchat':
    ensure   => present,
    baseurl  => 'http://atlassian.artifactoryonline.com/atlassian/hipchat-yum-client',
    enabled  => true,
    gpgcheck => false,
  }

  package { 'hipchat4':
    ensure  => installed,
    require => Yumrepo['hipchat'],
  }
}
