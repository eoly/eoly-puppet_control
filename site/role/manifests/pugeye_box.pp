class role::pugeye_box inherits roles {
  class { '::profile::eolsen': } ->
  class { '::profile::ssl': } ->
  class { '::profile::openvpn_server': } ->
  class { '::profile::elasticsearch': } ->
  class { '::profile::redis': } ->
  class { [ '::profile::logstash_server','::profile::ddclient' ]: }
}
