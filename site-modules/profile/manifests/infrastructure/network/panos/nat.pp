class profile::infrastructure::network::panos::nat {
  panos_nat_policy { 'lan-clients':
    ensure                  => 'present',
    nat_type                => 'ipv4',
    from                    => ['LAN'],
    to                      => ['Internet'],
    service                 => 'any',
    source                  => ['192.168.0.0/24'],
    destination             => ['any'],
    source_translation_type => 'dynamic-ip-and-port',
    sat_interface           => 'loopback.1',
  }
}