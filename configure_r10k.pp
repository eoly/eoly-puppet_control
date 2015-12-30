######         ######
##  Configure R10k ##
######         ######

class { 'r10k':
  sources           => {
    'puppet' => {
      'remote'  => 'git://github.com/eoly/eoly-puppet_control.git',
      'basedir' => "${::settings::codedir}/environments",
      'prefix'  => false,
    }
  },
  install_options   => '--debug',
}
