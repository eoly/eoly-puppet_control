class profile::rbenv(
  $user,
) {
  class { 'rbenv':
    install_dir => "/home/${user}/rbenv",
    owner       => $user,
    group       => $user,
    latest      => true,
  }

  rbenv::plugin { 'sstephenson/ruby-build': }
}