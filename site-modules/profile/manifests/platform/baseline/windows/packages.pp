class profile::platform::baseline::windows::packages (
  Array[String] $pkgs
){

  Package {
    provider => chocolatey,
  }

  package { $pkgs:
    ensure => present
  }

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
