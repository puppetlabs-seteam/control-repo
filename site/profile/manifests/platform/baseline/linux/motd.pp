class profile::platform::baseline::linux::motd {
  $motd = @("MOTD"/L)
    ===========================================================

          Welcome to ${::hostname}

    Access  to  and  use of this server is  restricted to those
    activities expressly permitted by the system administration
    staff. If you arre not sure if it is allowed, then DO NOT DO IT.

    ===========================================================

    The operating system is: ${::operatingsystem}
            The domain is: ${::domain}

    | MOTD

  class { '::motd':
    content => $motd,
  }

  file { '/etc/issue':
    ensure  => file,
    content => $motd,
  }

}
