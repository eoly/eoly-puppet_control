class profile::docker (
  $user,
) {
  class { 'docker':
    manage_kernel => false,
    docker_users  => [ $user ],
  }
}