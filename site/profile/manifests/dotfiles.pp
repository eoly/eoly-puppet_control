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

  file {
    default:
      ensure  => link,
      owner   => $user,
      group   => $user,
      require => Vcsrepo["/home/${user}/dotfiles"],
    ;
    ["/home/${user}/.vimrc.after"]:
      target => "/home/${user}/dotfiles/vimrc.after"
    ;
    ["/home/${user}/.vimrc.bundles"]:
      target => "/home/${user}/dotfiles/vimrc.bundles"
    ;
    ["/home/${user}/.puppet-lint.rc"]:
      target => "/home/${user}/dotfiles/puppet-lint.rc"
    ;
  }
}
