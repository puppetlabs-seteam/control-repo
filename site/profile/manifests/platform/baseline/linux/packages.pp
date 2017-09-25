# @summary This profile installs unzip and git as part of the Linux baseline
class profile::platform::baseline::linux::packages {

  $pkgs = ['unzip','wget']

  ensure_packages($pkgs, {ensure => installed})

  if $::osfamily == 'RedHat' {
    include ::epel
  }

}
