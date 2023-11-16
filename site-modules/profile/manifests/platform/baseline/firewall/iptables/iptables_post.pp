#
# Default rules for iptables
#
class profile::platform::baseline::firewall::iptables::iptables_post {
  firewall { '999 drop all':
    proto  => 'all',
    jump   => 'drop',
    before => undef,
  }
}
