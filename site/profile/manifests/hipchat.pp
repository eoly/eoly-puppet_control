class profile::hipchat {
  yumrepo { 'hipchat':
    ensure   => present,
    baseurl  => 'http://atlassian.artifactoryonline.com/atlassian/hipchat-yum-client',
    enabled  => true,
    gpgcheck => false,
  }

  package { 'HipChat':
    ensure  => installed,
    require => Yumrepo['hipchat'],
  }
}
