class profile::platform::baseline::windows::bootstrap {

  require ::chocolatey

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

  registry::value { 'enable insecure winrm':
    key    => 'HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\WinRM\Service',
    value  => 'AllowUnencryptedTraffic',
    data   => '1',
    type   => 'dword',
    notify => Service['WinRM'],
  }

  service {'WinRM':
    ensure => 'running',
    enable => true,
  }

}
