class profile::platform::baseline::linux::firewall (
  $purge = false,
) {

  Firewall {
    before  => Class['profile::platform::baseline::linux::firewall_post'],
    require => Class['profile::platform::baseline::linux::firewall_pre'],
  }

  class { ['::profile::platform::baseline::linux::firewall_pre', '::profile::platform::baseline::linux::firewall_post']: }

  resources { 'firewall':
    purge => $purge,
  }

  include ::firewall

}
