######         ######
##  Configure R10k ##
######         ######

class { 'r10k':
  version           => '1.3.4',
  sources           => {
    'puppet' => {
      'remote'  => 'git://github.com/eoly/eoly-puppet_control.git',
      'basedir' => "${::settings::confdir}/environments",
      'prefix'  => false,
    }
  },
  purgedirs         => ["${::settings::confdir}/environments"],
  manage_modulepath => false,
  install_options   => '--debug',
}
