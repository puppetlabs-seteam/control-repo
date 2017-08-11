class profile::platform::baseline::windows::common {

  reboot {'dsc_install':
    subscribe => Package['powershell'],
    apply     => 'immediately',
    timeout   => 0,
  }

  reboot{'dsc_reboot':
    when    => pending,
    timeout => 15,
  }

}
