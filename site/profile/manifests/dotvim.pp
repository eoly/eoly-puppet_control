class profile::dotvim (
  $user,
  $repo = 'https://github.com/eoly/dotvim.git'
) {

  vcsrepo { "/home/${user}/dotvim":
    ensure   => latest,
    provider => git,
    source   => $repo,
    user     => $user
  }

  file { "/home/${user}/.vim":
    ensure  => link,
    owner   => $user,
    group   => $user,
    target  => "/home/${user}/dotvim",
    require => Vcsrepo["/home/${user}/dotvim"]
  }

  file { "/home/${user}/.vimrc":
    ensure  => link,
    owner   => $user,
    group   => $user,
    target  => "/home/${user}/dotvim/vimrc",
    require => Vcsrepo["/home/${user}/dotvim"]
  }

}