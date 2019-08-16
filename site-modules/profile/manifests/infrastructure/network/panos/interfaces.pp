class profile::infrastructure::network::panos::interfaces {
  panos_arbitrary_commands {
    'devices/entry/network/profiles/interface-management-profile':
      ensure => 'present',
      xml    => '<interface-management-profile>
                  <entry name="ping">
                    <ping>yes</ping>
                  </entry>
                </interface-management-profile>';
  }

  panos_arbitrary_commands {
    'devices/entry/network/interface/loopback':
      ensure  => 'present',
      xml     => '<loopback>
                    <units>
                    <entry name="loopback.1">
                      <adjust-tcp-mss>
                        <enable>no</enable>
                      </adjust-tcp-mss>
                      <comment>WAN</comment>
                      <ip>
                        <entry name="10.10.10.10/32"/>
                      </ip>
                    </entry>
                      <entry name="loopback.2">
                        <adjust-tcp-mss>
                          <enable>no</enable>
                        </adjust-tcp-mss>
                        <comment>LAN</comment>
                        <interface-management-profile>ping</interface-management-profile>
                      </entry>
                    </units>
                  </loopback>',
      require => Panos_arbitrary_commands['devices/entry/network/profiles/interface-management-profile']
  }

  panos_virtual_router { 'default':
    ensure         => 'present',
    interfaces     => ['loopback.1', 'loopback.2'],
    ad_static      => '10',
    ad_static_ipv6 => '10',
    ad_ospf_int    => '30',
    ad_ospf_ext    => '110',
    ad_ospfv3_int  => '30',
    ad_ospfv3_ext  => '110',
    ad_ibgp        => '200',
    ad_ebgp        => '20',
    ad_rip         => '120',
    require        => Panos_arbitrary_commands['devices/entry/network/interface/loopback']
  }
}