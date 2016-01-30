class role::elk inherits role {
  class { '::profile::ssl': } ->
  class { '::profile::elk': }
}
