class profile::eolsen {

  include profile::vim

  class { 'profile::dotvim':
    user => 'eolsen'
  }

}
