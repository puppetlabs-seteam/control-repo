# @summary This profile installs unzip and git as part of the Linux baseline
class profile::platform::baseline::linux::packages (
  Array[String] $pkgs
){

  # EPEL is not supported on Amazon Linux 2023
  if $facts['os']['family'] == 'RedHat' and $facts['os']['name'] != 'Amazon' {
    include ::epel
  }

  ensure_packages($pkgs, {ensure => installed})

  # The cron resource type (used by PE patch management, pe_patch) needs crontab on the node.
  # Minimal images such as Amazon Linux 2023 ship without it, so install and run cron everywhere.
  $cron_package = $facts['os']['family'] ? {
    'RedHat' => 'cronie',
    'Debian' => 'cron',
    default  => undef,
  }
  $cron_service = $facts['os']['family'] ? {
    'RedHat' => 'crond',
    'Debian' => 'cron',
    default  => undef,
  }
  if $cron_package {
    ensure_packages([$cron_package], {ensure => installed})
    # CIS (sce_linux) manages the cron daemon itself when it is applied
    if !defined(Class['sce_linux']) {
      service { $cron_service:
        ensure  => running,
        enable  => true,
        require => Package[$cron_package],
      }
    }
    # Install crontab before any cron job is managed, so the first run doesn't fail
    Package[$cron_package] -> Cron <| |>
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
