class profile::platform::baseline::windows::bootstrap {

  require ::chocolatey

  if versioncmp($::powershell_version, '5.1.0') <= 0 {
    #notify{"version was less than":}

    # service needs to be running to install the update
    service { 'wuauserv':
      ensure => 'running',
      enable => true,
    }

    # disable auto updating so machine doesnt start downloading / updating
    registry::value { 'disable updates':
      key   => 'HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU',
      value => 'NoAutoUpdate',
      data  => '1',
      type  => 'dword',
    }

    # Get WMF
    package { 'powershell':
      ensure   => latest,
      #install_options => ['-pre','--ignore-package-exit-codes'],
      provider => chocolatey,
    }

    reboot {'dsc_install':
      subscribe => Package['powershell'],
      apply     => 'immediately',
      timeout   => 0,
    }

  }

}
