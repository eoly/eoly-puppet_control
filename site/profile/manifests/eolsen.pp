class profile::eolsen {

  $user = 'eolsen'

  include profile::vim

  class { 'profile::dotvim':
    user => $user
  }

  class { 'profile::dotfiles':
    user => $user
  }

  class { 'profile::eyaml':
    user => $user
  }

  class { 'profile::puppet_lint':
    user => $user
  }

}
