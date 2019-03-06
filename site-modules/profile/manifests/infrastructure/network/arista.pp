class profile::infrastructure::network::arista (
  Hash $interfaces = {},
) {

  package { 'rbeapi':
    ensure   => 'installed',
    provider => 'puppet_gem',
  }

  $interfaces.each |$interface, $parameters| {
    eos_ipinterface { $interface:
      ensure  => 'present',
      address => $parameters[ipaddress],
      mtu     => $parameters[mtu],
    }
  }

  eos_interface { 'Loopback1':
    ensure => 'present',
    enable => true,
  }

  eos_vxlan { 'Vxlan1':
    source_interface => 'Loopback1',
    udp_port         => 5500,
    require          => Eos_interface['Loopback1'],
  }

  eos_bgp_config { '65001':
    ensure             => present,
    enable             => true,
    router_id          => '192.0.2.4',
    maximum_paths      => 8,
    maximum_ecmp_paths => 8,
  }

  eos_bgp_neighbor { '192.0.3.1':
    ensure         => present,
    enable         => true,
    peer_group     => 'Edge',
    remote_as      => 65004,
    send_community => 'enable',
    next_hop_self  => 'enable',
  }
}
