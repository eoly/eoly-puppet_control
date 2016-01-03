class profile::openvpn_lnode1 {

  include '::openvpn'

  openvpn::conf { 'openvpn':
    source => "puppet:///modules/${module_name}/openvpn_lnode1.conf"
  }

}
