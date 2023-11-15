#
# Baseline profile to manage host based firewalls on all systems
#
# @param allow_egress
# @param allow_ingress_icmpv4
#   Permit ICMP protocol to allow pings
# @param allow_ingress
#   An array of hases of inbound port values to allow through the firewall in addition to the defaults. E.g.:
#   [
#     { 'name' => 'SSH', 'port' => 22, 'protocol' => 'tcp', 'description' => 'Allow SSH port 22 inbound' },
#     { 'name' => 'HTTP', 'port' => 80, 'protocol' => 'tcp', 'description' => 'Allow HTTP Web port 80 inbound' },
#   ]
#
#   Note: Default is 100% restricted with no inbound access.
#
# @param allow_ingress_windows_default
#   Default array of hashes to allow in Windows based hosts. Can be overriden to lock things down.
#
# @param allow_ingress_linux_default
#   Default array of hashes to allow in Windows based hosts. Can be overriden to lock things down.
#
class profile::platform::baseline::firewall (
  Boolean $allow_egress = true,
  Boolean $allow_ingress_icmpv4 = true,
  Array[Hash] $allow_ingress = [],
  Array[Hash] $allow_ingress_windows_default = [
    #lint:ignore:140chars
    { 'name' => 'WinRM',  'port' => 5985, 'protocol' => 'tcp', 'description' => 'Allow Windows Remote Management (WinRM) inbound' },
    { 'name' => 'WinRMS', 'port' => 5986, 'protocol' => 'tcp', 'description' => 'Allow Windows Remote Management (WinRM) over SSL inbound' },
    { 'name' => 'RDP',    'port' => 3389, 'protocol' => 'tcp', 'description' => 'Allow Remote Desktop Protocol (RDP) inbound' },
    #lint:endignore
  ],
  Array[Hash] $allow_ingress_linux_default = [
    { 'name' => 'SSH', 'port' => 22, 'protocol' => 'tcp', 'description' => 'Allow Secure Shell (SSH) inbound' },
  ],
) {
  # Host based firewall management varies by OS type/version, we need to determine the firewall type to manage
  $os_firewalls = {
    'alma' => {
      '8' => 'firewalld',
      '9' => 'firewalld',
    },
    'centos' => {
      '7' => 'iptables',
      '8' => 'firewalld',
    },
    'oraclelinux' => {
      '7' => 'iptables',
      '8' => 'firewalld',
      '9' => 'firewalld',
    },
    'redhat' => {
      '7' => 'iptables',
      '8' => 'firewalld',
      '9' => 'firewalld',
    },
    'rocky' => {
      '8' => 'firewalld',
      '9' => 'firewalld',
    },
    'ubuntu' => {
      '20.04' => 'ufw',
      '22.04' => 'ufw',
    },
    'windows' => {
      '10'   => 'windows',
      '11'   => 'windows',
      '2016' => 'windows',
      '2019' => 'windows',
      '2022' => 'windows',
    },
  }

  $firewall_type = $os_firewalls[$facts['os']['name'].downcase()][$facts['os']['release']['major']]

  # Apply the applicable firewall type
  case $firewall_type {
    'windows':   { include profile::platform::baseline::firewall::windows }
    'iptables':  { include profile::platform::baseline::firewall::iptables }
    'firewalld': { include profile::platform::baseline::firewall::firewalld }
    'ufw':       { include profile::platform::baseline::firewall::ufw }
    default:     { fail("Platform baseline firewall type could not be determined based on OS Name: '${facts['os']['name']}' and Major Version: '${facts['os']['release']['major']}'.") } #lint:ignore:140chars
  }
}
