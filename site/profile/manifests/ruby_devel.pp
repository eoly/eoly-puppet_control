class profile::ruby_devel {

  class { 'rbenv':
    latest      => true,
    manage_deps => false,
  }

  rbenv::plugin { 'sstephenson/ruby-build': }
  
}
