class profile::platform::baseline::linux::firewall {

  Firewall {
    before  => Class['profile::platform::baseline::linux::firewall_post'],
    require => Class['profile::platform::baseline::linux::firewall_pre'],
  }

  class { ['::profile::platform::baseline::linux::firewall_pre', '::profile::platform::baseline::linux::firewall_post']: }


  include ::firewall

}
