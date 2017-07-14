class profile::platform::baseline::general::linux::firewall {

  Firewall {
    before  => Class['profile::platform::baseline::general::linux::firewall_post'],
    require => Class['profile::platform::baseline::general::linux::firewall_pre'],
  }

  class { ['::profile::platform::baseline::general::linux::firewall_pre', '::profile::platform::baseline::general::linux::firewall_post']: }

  resources { 'firewall':
    purge => true,
  }

  include ::firewall

}
