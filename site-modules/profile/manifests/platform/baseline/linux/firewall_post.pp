class profile::platform::baseline::linux::firewall_post {
  firewall { '999 drop all':
    proto  => 'all',
    jump   => 'drop',
    before => undef,
  }
}
