class profile::app::nagios::target {

  # add hostname/ip exported resrouce here for server to collect

  @@host { $::fqdn:
    ip => $::ipaddress,
  }

  @@nagios_host { $::fqdn:
    ensure  => present,
    alias   => $::hostname,
    address => $::ipaddress,
    use     => 'linux-server',
  }
  @@nagios_service { "check_ping_${::hostname}":
    check_command       => 'check_ping!100.0,20%!500.0,60%',
    use                 => 'generic-service',
    host_name           => $::fqdn,
    notification_period => '24x7',
    service_description => "${::hostname}_check_ping",
  }

  Host <<||>>

}
