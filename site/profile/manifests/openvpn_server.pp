class profile::openvpn_server {

  include '::openvpn'

  openvpn::conf { 'openvpn':
    source => "puppet:///modules/${module_name}/openvpn_pugeye.conf"
  }

}
