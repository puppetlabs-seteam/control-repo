# class: profile::platform::baseline::windows::motd
#
class profile::platform::baseline::windows::motd {
  if !defined(Class['sce_windows']) {
    $motd = @("MOTD"/L)
      ===========================================================

           Welcome to ${facts['networking']['hostname']}

      Access  to  and  use of this server is  restricted to those
      activities expressly permitted by the system administration
      staff. If you are not sure if it is allowed, then DO NOT DO IT.

      ===========================================================

      The operating system is: ${facts['os']['name']}
              The domain is: ${facts['networking']['domain']}

      | MOTD


    # Check if we have a hiera override for the MOTD, otherwise use the default
    $message = lookup('motd', String, 'first', $motd)

    registry_value { '32:HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\policies\system\legalnoticecaption':
      ensure => present,
      type   => string,
      data   => 'Message of the day',
    }

    registry_value { '32:HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\policies\system\legalnoticetext':
      ensure => present,
      type   => string,
      data   => $message,
    }
  }
}

