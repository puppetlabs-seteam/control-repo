class profile::platform::compliance::cis {

  case $::osfamily {
    'windows': { include ::profile::platform::compliance::cis::windows }
    default: {
      fail('Unsupported OS')
    }
  }

}
