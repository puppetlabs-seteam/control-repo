# @summary This profile installs unzip and git as part of the Linux baseline
class profile::platform::baseline::linux::packages (
  Array[String] $pkgs
){

  if $facts['os']['family'] == 'RedHat' {
    include ::epel
  }

  ensure_packages($pkgs, {ensure => installed})

  if defined(Class['servicenow_cmdb_integration']) {
    unless getvar('trusted.external.servicenow.u_enforced_packages').empty {
      $packages = parsejson($trusted['external']['servicenow']['u_enforced_packages'])
      $packages.each |$package,$ensure|{
        package { $package:
          ensure => $ensure
        }
      }
    }
  }
}
