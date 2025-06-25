class profile::app::webserver::apache::php {
  if $facts['os']['family'] == 'RedHat' and $facts['os']['release']['major'] == '9' {
    # RHEL9 (technically 8...) and above don't use mod_php
  } elsif $facts['os']['name'] == 'Ubuntu' and $facts['os']['release']['major'] >= '24.04' {
    # Ubuntu 24.04 and above don't use mod_php
  } else {
    include ::apache::mod::php
  }
}
