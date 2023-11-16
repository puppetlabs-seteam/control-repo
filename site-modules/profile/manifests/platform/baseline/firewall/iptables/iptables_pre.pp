#
# Rules for iptables
#
# @param allow_ingress_icmpv4
#   Allow ICMP v4 protocol (ping, traceroute, etc.)
# @param allow_ingress
#  Hash of ingress rules to allow, see parent profile class for syntax
#
class profile::platform::baseline::firewall::iptables::iptables_pre (
  Boolean $allow_ingress_icmpv4 = $profile::platform::baseline::firewall::iptables::allow_ingress_icmpv4,
  Array[Hash] $allow_ingress = $profile::platform::baseline::firewall::iptables::allow_ingress,
) {
  Firewall { require => undef, }

  # Allow local interface traffic
  firewall { '001 accept all to lo interface':
    proto   => 'all',
    iniface => 'lo',
    jump    => 'accept',
  }

  # ICMPv4
  if ($allow_ingress_icmpv4) {
    firewall { '000 accept icmpv4 protocol':
      proto => 'icmp',
      jump  => 'accept',
    }
  }

  # Allow traffic related to established connections
  firewall { '002 accept related established rules':
    proto => 'all',
    state => ['RELATED', 'ESTABLISHED'],
    jump  => 'accept',
  }

  # Loop through ingress rules
  $allow_ingress.each | Hash $in | {
    firewall { "100 accept ${in['name']} ${in['protocol'].downcase()}-${in['port']}":
      proto => $in['protocol'].downcase(),
      dport => $in['port'],
      jump  => 'accept',
    }
  }
}
