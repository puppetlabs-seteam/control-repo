class profile::infrastructure::network::panos::security_policies {
  resources { 'panos_security_policy_rule':
    purge => true,
  }

  panos_arbitrary_commands {
    'devices/entry/vsys/entry/application-filter':
      ensure => 'present',
      xml    => '<application-filter>
                    <entry name="Internet">
                      <category>
                        <member>general-internet</member>
                      </category>
                    </entry>
                  </application-filter>';
  }

  panos_security_policy_rule { 'Internet Access':
    ensure                             => 'present',
    rule_type                          => 'universal',
    source_zones                       => ['LAN'],
    source_address                     => ['192.168.0.0/24'],
    negate_source                      => false,
    source_users                       => ['any'],
    hip_profiles                       => ['any'],
    destination_zones                  => ['Internet'],
    destination_address                => ['any'],
    negate_destination                 => false,
    applications                       => ['Internet', 'ssl'],
    services                           => ['any'],
    categories                         => ['any'],
    action                             => 'allow',
    icmp_unreachable                   => false,
    log_start                          => false,
    log_end                            => false,
    profile_type                       => 'none',
    qos_type                           => 'none',
    disable_server_response_inspection => false,
    disable                            => false,
    insert_after                       => '',
    require                            => [ Panos_zone['Internet'], Panos_zone['LAN'], Panos_arbitrary_commands['devices/entry/vsys/entry/application-filter'] ]
  }

  panos_security_policy_rule { 'Data Center Applications':
    ensure                             => 'present',
    rule_type                          => 'universal',
    source_zones                       => ['LAN'],
    source_address                     => ['any'],
    negate_source                      => false,
    source_users                       => ['any'],
    hip_profiles                       => ['any'],
    destination_zones                  => ['Data Center'],
    destination_address                => ['any'],
    negate_destination                 => false,
    applications                       => ['active-directory', 'imap'],
    services                           => ['application-default'],
    categories                         => ['any'],
    action                             => 'allow',
    icmp_unreachable                   => false,
    log_start                          => false,
    log_end                            => false,
    profile_type                       => 'none',
    qos_type                           => 'none',
    disable_server_response_inspection => false,
    disable                            => false,
    insert_after                       => 'Internet Access',
  }

  panos_security_policy_rule { 'Client VPN':
    ensure                             => 'present',
    rule_type                          => 'universal',
    source_zones                       => ['LAN'],
    source_address                     => ['any'],
    negate_source                      => false,
    source_users                       => ['any'],
    hip_profiles                       => ['any'],
    destination_zones                  => ['any'],
    destination_address                => ['100.64.0.0-100.127.255.255'],
    negate_destination                 => false,
    applications                       => ['open-vpn'],
    services                           => ['application-default'],
    categories                         => ['any'],
    action                             => 'allow',
    icmp_unreachable                   => false,
    log_start                          => false,
    log_end                            => false,
    profile_type                       => 'none',
    qos_type                           => 'none',
    disable_server_response_inspection => false,
    disable                            => false,
    insert_after                       => 'Data Center Applications',
    require                            => Panos_zone['Data Center'],
  }
}