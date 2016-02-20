class profile::google_chrome {
  $rpm_url = 'https://dl.google.com/linux/direct/google-chrome-stable_current_x86_64.rpm'

  package { 'google-chrome-stable_current':
    ensure   => installed,
    provider => dnf,
    source   => $rpm_url
  }
}