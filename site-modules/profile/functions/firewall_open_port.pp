function profile::firewall_open_port(String $name, String $protocol, Integer $port, String $description) >> Boolean {
  $firewall_type = profile::firewall_type($facts['os']['name'], $facts['os']['release']['major'])
  case $firewall_type {
    'iptables': {
      firewall { "200 Allow ${name}":
        dport => $port,
        proto => $protocol.downcase(),
        jump  => accept,
      }
    }
    'firewalld': {
      firewalld_port { "Allow ${name}":
        ensure   => present,
        zone     => 'public',
        port     => $port,
        protocol => $protocol.downcase(),
      }
    }
    'ufw': {
      ufw_rule { "Allow ${name}":
        ensure       => present,
        action       => 'allow',
        direction    => 'in',
        interface    => undef,
        to_ports_app => $port,
        proto        => $protocol.downcase(),
      }
    }
    'windows': {
      windows_firewall_rule { "Allow ${name} - Puppet Managed":
        ensure       => present,
        direction    => 'inbound',
        action       => 'allow',
        enabled      => true,
        protocol     => $protocol.downcase(),
        local_port   => String($port),
        display_name => "${protocol.upcase()} ${port} - ${name} - Puppet Managed",
        description  => $description,
      }
    }
    default: { fail("Firewall type could not be determined for '${facts['os']['name']} ${facts['os']['release']['major']}'") }
  }
  true
}
