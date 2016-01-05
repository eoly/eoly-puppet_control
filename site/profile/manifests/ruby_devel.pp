class profile::ruby_devel {

  class { 'rbenv':
    latest      => true,
    manage_deps => true,
  }

  rbenv::plugin { 'sstephenson/ruby-build': }
  
}
