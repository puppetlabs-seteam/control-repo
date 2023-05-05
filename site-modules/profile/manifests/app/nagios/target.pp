class profile::app::nagios::target {

  # add hostname/ip exported resrouce here for server to collect

  @@host { $facts['networking']['fqdn']:
    ip => $facts['networking']['ip'],
  }

  @@nagios_host { $facts['networking']['fqdn']:
    ensure  => present,
    alias   => $facts['networking']['hostname'],
    address => $facts['networking']['ip'],
    use     => 'linux-server',
  }
  @@nagios_service { "check_ping_${facts['networking']['hostname']}":
    check_command       => 'check_ping!100.0,20%!500.0,60%',
    use                 => 'generic-service',
    host_name           => $facts['networking']['fqdn'],
    notification_period => '24x7',
    service_description => "${facts['networking']['hostname']}_check_ping",
  }

  Host <<||>>

}
