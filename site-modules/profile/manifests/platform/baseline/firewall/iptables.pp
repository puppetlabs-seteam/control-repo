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
class profile::platform::baseline::firewall::iptables (
  Boolean $allow_egress         = $profile::platform::baseline::firewall::allow_egress,
  Boolean $allow_ingress_icmpv4 = $profile::platform::baseline::firewall::allow_ingress_icmpv4,
  Array[Hash] $allow_ingress    = $profile::platform::baseline::firewall::allow_ingress_linux_default + $profile::platform::baseline::firewall::allow_ingress, #lint:ignore:140chars
) {
  Firewall {
    before  => Class['profile::platform::baseline::firewall::iptables::iptables_post'],
    require => Class['profile::platform::baseline::firewall::iptables::iptables_pre'],
  }

  class {['firewall','profile::platform::baseline::firewall::iptables::iptables_pre', 'profile::platform::baseline::firewall::iptables::iptables_post']: } #lint:ignore:140chars

  resources { 'firewall': purge => true, }
}
