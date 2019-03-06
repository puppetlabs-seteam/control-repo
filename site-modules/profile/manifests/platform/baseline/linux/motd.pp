class profile::platform::baseline::linux::motd {
  $motd = @("MOTD"/L)
    ===========================================================

          Welcome to ${::hostname}

    Access  to  and  use of this server is  restricted to those
    activities expressly permitted by the system administration
    staff. If you are not sure if it is allowed, then DO NOT DO IT.

    ===========================================================

    The operating system is: ${::operatingsystem}
            The domain is: ${::domain}

    | MOTD


  # Check if we have a hiera override for the MOTD, otherwise use the default
  $message = lookup('motd', String, 'first', $motd)

  class { '::motd':
    content => $message,
  }

  if !defined(File['/etc/issue']){

    file { '/etc/issue':
      ensure  => file,
      content => $message,
    }

  }

}
