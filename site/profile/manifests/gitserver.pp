class profile::gitserver {

  $password         = hiera('profile::gitserver::password')
  $authorized_keys  = hiera('profile::gitserver::authorized_keys')

  user { 'git':
    ensure         => present,
    home           => '/home/git',
    shell          => '/bin/git-shell',
    managehome     => true,
    password       => $password,
    purge_ssh_keys => true
  }

  $authorized_keys.each |$key, $value| {
    ssh_authorized_key { $key:
      user    => 'git',
      type    => 'ssh-rsa',
      key     => $value,
    }
  }
}
