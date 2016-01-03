class profile::eolsen {

  $eolsen_user = hiera('eolsen_user')

  validate_hash($eolsen_user)
  validate_string($eolsen_user[password])
  validate_array($eolsen_user[groups])

  user { 'eolsen':
    ensure     => present,
    password   => $eolsen_user[password],
    groups     => $eolsen_user[groups],
    managehome => true,
    home       => '/home/eolsen',
  }

  vcsrepo { '/home/eolsen/.vim':
    ensure   => present,
    provider => 'git',
    source   => 'https://github.com/eoly/eoly-vimrc.git',
    user     => 'eolsen',
    require  => User['eolsen'],
  }

}
