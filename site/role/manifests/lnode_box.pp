class role::lnode_box inherits role {
  class { '::profile::eolsen': } ->
  class { '::profile::ruby_devel': } ->
  class { '::profile::ssl': } ->
  class { '::profile::postfix': } ->
  class { '::profile::apache': }
}
