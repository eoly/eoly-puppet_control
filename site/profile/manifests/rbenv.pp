class profile::rbenv(
  $user,
) {
  class { 'rbenv':
    install_dir => "/home/${user}/.rbenv",
    owner       => $user,
    group       => $user,
    latest      => true,
  }

  rbenv::plugin { 'sstephenson/ruby-build': }

  rbenv::build { '2.0.0-p648': }
  rbenv::build { '1.9.3-p551': }

}