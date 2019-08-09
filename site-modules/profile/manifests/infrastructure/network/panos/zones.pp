class profile::infrastructure::network::panos::zones {
  panos_zone { 'Internet':
    ensure                          => 'present',
    network                         => 'layer3',
    interfaces                      => ['loopback.1'],
    enable_user_identification      => false,
    enable_packet_buffer_protection => false,
    nsx_service_profile             => false,
  }
  panos_zone { 'LAN':
    ensure                          => 'present',
    network                         => 'layer3',
    interfaces                      => ['loopback.2'],
    enable_user_identification      => false,
    enable_packet_buffer_protection => false,
    nsx_service_profile             => false,
  }
  panos_zone { 'Data Center':
    ensure                          => 'present',
    network                         => 'layer3',
    enable_user_identification      => false,
    enable_packet_buffer_protection => false,
    nsx_service_profile             => false,
  }
}