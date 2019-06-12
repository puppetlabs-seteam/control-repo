class profile::platform::baseline::windows::firewall {

  class { '::windows_firewall':
    ensure => 'running',
  }

  windows_firewall::exception { 'Permit ICMPv4':
    ensure       => present,
    direction    => 'in',
    action       => 'allow',
    enabled      => true,
    protocol     => 'ICMPv4',
    display_name => 'Permit ICMPv4',
    description  => 'Permit ICMPv4',
  }

  windows_firewall::exception { 'WINRM':
    ensure       => present,
    direction    => 'in',
    action       => 'allow',
    enabled      => true,
    protocol     => 'TCP',
    local_port   => 5985,
    remote_port  => 'any',
    display_name => 'Windows Remote Management HTTP-In',
    description  => 'Inbound rule for Windows Remote Management via WS-Management. [TCP 5985]',
  }

  windows_firewall::exception { 'RDP':
    ensure       => present,
    direction    => 'in',
    action       => 'allow',
    enabled      => true,
    protocol     => 'TCP',
    local_port   => 3889,
    remote_port  => 'any',
    display_name => 'Windows RDP',
    description  => 'Inbound rule for Windows RDP. [TCP 3889]',
  }
}
