#
# Host based firewall for Windows systems
#
# @param allow_egress
#    Allow outbound traffic
# @param allow_ingress_icmpv4
#    Allow pings
# @param allow_ingress
#    Allow a list of inbound ports. See parent profile (profile::platform::baseline::firewall) for syntax example.
#
class profile::platform::baseline::firewall::windows (
  Boolean $allow_egress         = $profile::platform::baseline::firewall::allow_egress,
  Boolean $allow_ingress_icmpv4 = $profile::platform::baseline::firewall::allow_ingress_icmpv4,
  Array[Hash] $allow_ingress    = $profile::platform::baseline::firewall::allow_ingress_windows_default + $profile::platform::baseline::firewall::allow_ingress, #lint:ignore:140chars
) {
  # Purge all unmanaged rules
  resources { 'windows_firewall_rule': purge => true, }

  # Set the default outbound action
  $outbound_policy = $allow_egress ? { true => 'allowoutbound', false => 'blockoutbound' }
  windows_firewall_profile { ['domain','public','private']:
    inboundusernotification    => 'disable',
    firewallpolicy             => "blockinbound,${outbound_policy}",
    remotemanagement           => 'disable',
    state                      => true,
    unicastresponsetomulticast => 'disable',
  }

  if ($allow_ingress_icmpv4) {
    windows_firewall_rule { 'Permit ICMPv4':
      ensure       => present,
      direction    => 'inbound',
      action       => 'allow',
      enabled      => true,
      protocol     => 'icmpv4',
      display_name => 'Permit ICMPv4',
      description  => 'Permit ICMPv4',
    }
  }

  $allow_ingress.each | Hash $in | {
    windows_firewall_rule { $in['name']:
      ensure       => present,
      direction    => 'inbound',
      action       => 'allow',
      enabled      => true,
      protocol     => $in['protocol'].downcase(),
      local_port   => String($in['port']),
      remote_port  => 'any',
      display_name => "${in['name']} - Inbound - Puppet Managed",
      description  => "[${in['protocol'].upcase()}-${in['port']}] ${in['name']} ${in['description']} - Puppet Managed",
    }
  }
}
