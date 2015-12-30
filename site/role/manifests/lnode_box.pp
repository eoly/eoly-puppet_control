class role::lnode_box inherits roles {
  class { '::profile::eolsen': } ->
  class { '::profile::ssl': } ->
  class { '::profile::postfix': } ->
  class { '::profile::apache': }
}
