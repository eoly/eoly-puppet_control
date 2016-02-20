class profile::dotvim (
  $user,
  $repo = 'https://github.com/eoly/dotvim.git'
) {

  vcsrepo { "/home/${user}/dotvim":
    ensure   => present,
    provider => git,
    source   => $repo
  }

  file { "/home/${user}/.vim":
    ensure  => link,
    user    => $user,
    group   => $user,
    target  => "/home/${user}/dotvim",
    require => Vcsrepo["/home/${user}/dotvim"]
  }

  file { "/home/${user}/.vimrc":
    ensure  => link,
    user    => $user,
    group   => $user,
    target  => "/home/${user}/dotvim/vimrc",
    require => Vcsrepo["/home/${user}/dotvim"]
  }

}