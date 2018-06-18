class profile::ios_demo (
  Hash $banner = {},
  Hash $network_dns = {},
  Hash $syslog_settings = {},
  Hash $syslog_servers = {},
  Hash $interfaces = {},
  Hash $vlans = {},
  Hash $commands = {},
) {

  # banner 
  banner { 'default':
    * => $banner,
  }

  # dns settings
  network_dns { 'default':
    * => $network_dns,
  }

  # vlan configuration
  $vlans.each |$vlan, $parameters| {
    network_vlan { $vlan:
      ensure    => $parameters[ensure],
      shutdown  => $parameters[shutdown],
      vlan_name => $parameters[vlan_name],
    }
  }

  # Level 3 interface configuration

  $vlans.each |$vlan, $parameters| {

    if $parameters[ipaddress] {

      $if_command = @("EOT")
        interface Vlan${vlan}
         ip address ${parameters[ipaddress]} ${parameters[broadcast]}
        | EOT

      ios_config { "${vlan}-lvl3-if":
        command          => $if_command,
        idempotent_regex => regsubst($if_command, '\n', '\\n', 'G'),
      }
    }
  }

  # Syslog server configuration

  syslog_settings { 'default':
    * => $syslog_settings,
  }

  $syslog_servers.each | $syslog_server, $params | {
    syslog_server {  $syslog_server:
      * => $params,
    }
  }

  # Switch port configuration

  $interfaces.each |$interface, $parameters| {
    network_interface { $interface:
      enable => true,
      *      => $parameters,
    }
  }

  # execute commands defined in hiera
  $commands.each |$name, $value| {
    if $value =~ String {
      $command = $value
      $regex = $value
    } elsif $value =~ Hash {
      $command = $value[command]
      $idempotent_regex = $value[idempotent_regex]
      $multiline_regex = $value[multiline_regex]
      if $idempotent_regex {
        $regex = $idempotent_regex
      } elsif $multiline_regex {
        $regex = sprintf('%s(?!\s+)', regsubst($multiline_regex, '\n', '\\n', 'G'))
      } else {
        $regex = $command
      }
    }
    ios_config { $name:
      command          => $command,
      idempotent_regex => $regex,
    }
  }

}
