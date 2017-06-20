class profile::platform::compliance::cis {

  case $::osfamily {
    'windows': { include ::profile::compliance::cis::windows }
    default: {
      notify { 'unsupported operating system': }
    }
  }

}
