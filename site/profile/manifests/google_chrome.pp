class profile::google_chrome {
  yumrepo { 'google-chorme':
    ensure   => present,
    baseurl  => 'http://dl.google.com/linux/chrome/rpm/stable/$basearch',
    enabled  => true,
    gpgkey   => 'https://dl-ssl.google.com/linux/linux_signing_key.pub',
    gpgcheck => true
  }

  package { 'google-chrome-stable':
    ensure   => installed,
    require  => Yumrepo['google-chrome']
  }
}