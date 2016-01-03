class profile::java {

  class { '::java': }
  contain '::java'
  
}
