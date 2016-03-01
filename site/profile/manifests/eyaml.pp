class profile::eyaml (
  $user,
) {

  $app_tiers = ['dev','qa','uat','prod']

  $eyaml_config_dir = "/home/${user}/.eyaml"

  $config_file_tpl = @(END)
  <%- | String $config_dir,
  | -%>
  ---
  pkcs7_private_key: '<%=$config_dir%>/private_key.pkcs7.pem'
  pkcs7_public_key: '<%=$config_dir%>/public_key.pkcs7.pem'
  END

  $app_tiers.each |$app_tier| {
    $app_tier_config_dir = "${eyaml_config_dir}/${app_tier}"

    file { $app_tier_config_dir:
      ensure  => directory,
      owner   => $user,
      group   => $group,
      mode    => '0755',
      require => User[$user]
    }

    file { "${app_tier_config_dir}/config.yaml":
      ensure  => present,
      owner   => $user,
      group   => $user,
      mode    => '0644',
      content => inline_epp($config_file_tpl, { 'config_dir' => $app_tier_config_dir }),
      require => File[$app_tier_config_dir]
    }
  }

  package { 'hiera-eyaml':
    ensure   => present,
    provider => gem,
  }

}