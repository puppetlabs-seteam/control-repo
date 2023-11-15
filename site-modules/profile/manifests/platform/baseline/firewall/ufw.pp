#
# Host based firewall for Linux iptables based systems
#
# @param allow_egress
#    Allow outbound traffic
# @param allow_ingress_icmpv4
#    Allow pings
# @param allow_ingress
#    Allow a list of inbound ports. See parent profile (profile::platform::baseline::firewall) for syntax example.
#
class profile::platform::baseline::firewall::ufw (
  Boolean $allow_egress         = $profile::platform::baseline::firewall::allow_egress,
  Boolean $allow_ingress_icmpv4 = $profile::platform::baseline::firewall::allow_ingress_icmpv4,
  Array[Hash] $allow_ingress    = $profile::platform::baseline::firewall::allow_ingress_linux_default + $profile::platform::baseline::firewall::allow_ingress, #lint:ignore:140chars
) {
  class { 'ufw':
    manage_package         => true,
    manage_service         => true,
    purge_unmanaged_rules  => true,
    purge_unmanaged_routes => true,
    service_ensure         => 'running',
  }
  $allow_ingress.each | Hash $in | {
    ufw_rule { $in['name']:
      ensure       => present,
      action       => 'allow',
      direction    => 'in',
      interface    => undef,
      to_ports_app => $in['port'],
      proto        => $in['protocol'].downcase(),
    }
  }
}
