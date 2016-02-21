class profile::virtualbox {
  class { 'virtualbox':
    manage_repo => true,
  }
}
