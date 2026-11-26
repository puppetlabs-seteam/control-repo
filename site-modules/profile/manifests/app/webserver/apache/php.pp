class profile::app::webserver::apache::php {
  if $facts['os']['family'] == 'RedHat' and versioncmp($facts['os']['release']['major'], '9') >= 0 {
    # RedHat family 9 and above (RHEL 9, RHEL 10, Amazon Linux 2023) don't use mod_php.
    # RHEL 8 and older still get mod_php.
  } elsif $facts['os']['name'] == 'Ubuntu' and versioncmp($facts['os']['release']['major'], '24.04') >= 0 {
    # Ubuntu 24.04 and above don't use mod_php
  } else {
    include ::apache::mod::php
  }
}
