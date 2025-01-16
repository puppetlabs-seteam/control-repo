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
class profile::platform::baseline::firewall::firewalld (
  Boolean $allow_egress         = $profile::platform::baseline::firewall::allow_egress,
  Boolean $allow_ingress_icmpv4 = $profile::platform::baseline::firewall::allow_ingress_icmpv4,
  Array[Hash] $allow_ingress    = $profile::platform::baseline::firewall::allow_ingress_linux_default + $profile::platform::baseline::firewall::allow_ingress, #lint:ignore:140chars
) {

  class { 'firewalld':
    service_ensure            => running,
    service_enable            => true,
    package_ensure            => 'present',
    purge_direct_rules        => true,
    purge_direct_chains       => true,
    purge_direct_passthroughs => true,
    purge_unknown_ipsets      => true,
  }

  $icmp_block_inversion = $allow_ingress_icmpv4 ? { true => false, false => true }

  firewalld_zone { 'public':
    ensure               => present,
    target               => '%%REJECT%%',
    purge_rich_rules     => true,
    purge_services       => true,
    purge_ports          => true,
    icmp_blocks          => [],
    icmp_block_inversion => $icmp_block_inversion,
    masquerade           => false,
  }

  $allow_ingress.each | Hash $in | {
    firewalld_port { $in['name']:
      ensure   => present,
      zone     => 'public',
      port     => $in['port'],
      protocol => $in['protocol'].downcase(),
    }
  }
}
