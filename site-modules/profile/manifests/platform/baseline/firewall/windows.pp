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
  # Make sure the service is up and running
  class { 'windows_firewall': ensure => 'running', }

  # Set the default outbound action
  $default_outbound_action = $allow_egress ? { true => 'allow', false => 'deny' }
  windowsfirewall { ['domain','public','private']:
    ensure                  => present,
    default_outbound_action => $default_outbound_action,
  }

  if ($allow_ingress_icmpv4) {
    windows_firewall::exception { 'Permit ICMPv4':
      ensure       => present,
      direction    => 'in',
      action       => 'allow',
      enabled      => true,
      protocol     => 'ICMPv4',
      display_name => 'Permit ICMPv4',
      description  => 'Permit ICMPv4',
    }
  }

  $allow_ingress.each | Hash $in | {
    windows_firewall::exception { $in['name']:
      ensure       => present,
      direction    => 'in',
      action       => 'allow',
      enabled      => true,
      protocol     => $in['protocol'].upcase(),
      local_port   => $in['port'],
      remote_port  => 'any',
      display_name => "${in['name']} - Inbound - Puppet Managed",
      description  => "[${in['protocol'].upcase()}-${in['port']}] ${in['name']} ${in['description']} - Puppet Managed",
    }
  }
}
