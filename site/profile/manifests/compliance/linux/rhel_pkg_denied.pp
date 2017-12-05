class profile::compliance::linux::rhel_pkg_denied {

  $removed = [ 'telnet-server', 'rsh-server', 'tftp-server', 'vsftpd' ]

  # Passing above array into the package function
  package { $removed:
    ensure => absent,
  }

}
