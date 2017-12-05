class profile::compliance::linux::rhel_svc_denied (
  $http = false,
  $smb  = false,
  $nfs  = false,
  ) {

  $disabled_services = [ 'rhnsd', 'kdump', 'mdmonitor', 'pcscd', 'named', 'vsftpd', 'dovecot', 'squid', 'snmp' ]

  # Passing the above array into a resource that will ensure all services are stopped and disabled.
  service { $disabled_services:
    ensure  => 'stopped',
    enable => false,
  }

  # Using the above parameters to allow the consumer of the class to determine whether the services
  # need to be disabled
  unless $http {
    service { 'httpd':
      ensure  => 'stopped',
      enable => false,
    }
  }

  unless $nfs {
    service { 'nfslock':
      ensure  => 'stopped',
      enable => false,
    }
  }

  unless $smb {
    service { 'smb':
      ensure  => 'stopped',
      enable => false,
    }
  }
}
