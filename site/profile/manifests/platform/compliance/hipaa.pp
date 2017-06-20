class profile::platform::compliance::hipaa {

  case $::osfamily {
    'windows': { include ::profile::compliance::hipaa::windows }
    default: {
      notify { 'unsupported operating system': }
    }
  }
}
