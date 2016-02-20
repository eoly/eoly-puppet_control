class profile::dotvim (
  $user,
  $repo = 'https://github.com/eoly/dotvim.git'
) {

  vcsrepo { "/home/${user}/dotvim":
    ensure   => present,
    provider => git,
    source   => $repo
  }

  file { "/home/${user}/dotvim":
    ensure  => link,
    target  => "/home/${user}/.vim",
    require => Vcsrepo["/home/${user}/dotvim"]
  }

  file { "/home/${user}/dotvim/.vimrc":
    ensure  => link,
    target  => "/home/${user}/.vimrc",
    require => Vcsrepo["/home/${user}/dotvim"]
  }

}