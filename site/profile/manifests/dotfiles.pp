class profile::dotfiles (
  $user,
  $repo = 'https://github.com/eoly/dotfiles.git'
){

  vcsrepo { "/home/${user}/dotfiles":
    ensure   => latest,
    provider => git,
    source   => $repo,
    revision => 'master',
    user     => $user
  }

  file { "/home/${user}/.vimrc.after":
    ensure  => link,
    owner   => $user,
    group   => $user,
    target  => "/home/${user}/dotfiles/vimrc.after",
    require => Vcsrepo["/home/${user}/dotfiles"]
  }

  file { "/home/${user}/.vimrc.bundles":
    ensure  => link,
    owner   => $user,
    group   => $user,
    target  => "/home/${user}/dotfiles/vimrc.bundles",
    require => Vcsrepo["/home/${user}/dotfiles"]
  }

}
