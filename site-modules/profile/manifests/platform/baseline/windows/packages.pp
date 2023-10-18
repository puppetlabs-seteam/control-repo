class profile::platform::baseline::windows::packages {

  Package {
    provider => chocolatey,
  }

  $predefined_packages = [ 'notepadplusplus', '7zip', 'git', 'uniextract' ]
  package { $predefined_packages:
    ensure => present
  }

  unless getvar('trusted.external.servicenow.u_enforced_packages').empty {
    $packages = parsejson($trusted['external']['servicenow']['u_enforced_packages'])
    $packages.each |$package,$ensure|{
      package { $package:
        ensure => $ensure
      }
    }
  }
}
