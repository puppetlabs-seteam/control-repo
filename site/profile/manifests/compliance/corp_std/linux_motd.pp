class profile::compliance::corp_std::linux_motd {

  class { '::motd':
    content => "
  ===========================================================

        Welcome to ${::hostname}

  Access  to  and  use of this server is  restricted to those
  activities expressly permitted by the system administration
  staff. If you're not sure if it's allowed, then DON'T DO IT.

  ===========================================================

  The operating system is: ${::operatingsystem}
          The domain is: ${::domain}
  "
  }
}
