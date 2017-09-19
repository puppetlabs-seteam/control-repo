class profile::platform::baseline::windows::bootstrap {

  require ::chocolatey

  # Get WMF
  package { 'powershell':
    ensure          => latest,
    install_options => ['-pre','--ignore-package-exit-codes'],
    provider        => chocolatey,
  }

  reboot {'dsc_install':
    subscribe => Package['powershell'],
    apply     => 'immediately',
    timeout   => 0,
  }

}
