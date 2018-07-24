# profile::infrastructure::network::ios
# Demo profile for Cisco IOS devices
# Tested on Catalyst 3750 and Catalyst 2960
class profile::infrastructure::network::ios (
  Hash $interfaces = {},
  Hash $vlans = {},
  Hash $commands = {},
) {

  # Manage banner 
  banner { 'default':
    motd => 'Welcome to IOS!',
  }

  # Manage DNS
  network_dns { 'default':
    ensure  => 'present',
    servers => ['1.1.1.1', '1.1.1.3'],
    domain  => 'poc.com',
    search  => ['jim.com'],
  }

  # Syslog server default configuration
  syslog_settings { 'default':
    enable           => true,
    monitor          => 6,
    console          => 6,
    source_interface => ['Vlan2000'],
  }

  # Syslog servers
  syslog_server { ['192.188.11.1','192.188.11.2']:
    ensure => present,
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
