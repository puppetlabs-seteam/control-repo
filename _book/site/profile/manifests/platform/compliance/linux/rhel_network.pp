class profile::compliance::linux::rhel_network {

  # creating a hash of all desired sysctl settings. This should make the data more readable.
  $sysctl_settings_on = [
                         'net.ipv4.conf.all.log_martians',
                         'net.ipv4.icmp_echo_ignore_broadcasts',
                         'net.ipv4.tcp_syncookies',
                         'net.ipv4.conf.all.rp_filter',
                         'net.ipv4.conf.default.rp_filter',
                        ]
 $sysctl_settings_off = [
                        'net.ipv4.conf.all.accept_source_route',
                        'net.ipv4.conf.all.accept_redirects',
                        'net.ipv4.conf.all.secure_redirects',
                        'net.ipv4.conf.default.accept_source_route',
                        'net.ipv4.conf.default.accept_redirects',
                        'net.ipv4.conf.default.secure_redirects',
                       ]

  # Setting the defaults used below
  sysctl { $sysctl_settings_on:
    ensure    => present,
    value     => '1',
  }

  # Setting the defaults used below
  sysctl { $sysctl_settings_off:
    ensure    => present,
    value     => '0',
  }


}
