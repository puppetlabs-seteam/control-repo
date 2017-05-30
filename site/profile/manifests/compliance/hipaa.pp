class profile::compliance::hipaa {

  case $::osfamily {
    'RedHat': { include profile::compliance::hipaa::rhel }
    'Debian': { include profile::compliance::hipaa::debian }
    'windows': { include profile::compliance::hipaa::windows }
    default: { notify { 'unsupported operating system': } }
  }
}
