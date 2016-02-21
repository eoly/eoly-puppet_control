class profile::eolsen {

  $user = 'eolsen'

  include profile::vim

  class { 'profile::dotvim':
    user => $user
  }

  class { 'profile::dotfiles':
    user => $user
  }

}
