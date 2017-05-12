class profile::compliance::cis {
  
  case $::osfamily {
    'RedHat': { include profile::compliance::cis::rhel }
    'Debian': { include profile::compliance::cis::debian }
    'windows': { include profile::compliance::cis::windows }
    default: { fail( 'unsupported operating system' ) }
  }

}
