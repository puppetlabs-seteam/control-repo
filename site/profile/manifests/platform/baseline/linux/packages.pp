# @summary This profile installs unzip and git as part of the Linux baseline
class profile::platform::baseline::linux::packages {
  package { 'unzip':
    ensure => installed,
  }

}
