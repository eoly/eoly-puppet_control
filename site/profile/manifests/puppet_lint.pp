class profile::puppet_lint {
  package { ['puppet-lint',
  'puppet-lint-absolute_classname-check',
  'puppet-lint-leading_zero-check',
  'puppet-lint-trailing_comma-check',
  'puppet-lint-version_comparison-check',
  'puppet-lint-classes_and_types_beginning_with_digits-check',
  'puppet-lint-unquoted_string-check']:
    ensure   => present,
    provider => gem
  }
}
