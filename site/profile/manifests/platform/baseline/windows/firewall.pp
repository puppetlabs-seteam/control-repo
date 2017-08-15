class profile::platform::baseline::windows::firewall {

  class { 'windows_firewall':
    ensure => 'running'
  }

}
