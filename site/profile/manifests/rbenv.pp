class profile::rbenv {
  class { 'rbenv':
    latest => true,
  }

  rbenv::plugin { 'sstephenson/ruby-build': }
}