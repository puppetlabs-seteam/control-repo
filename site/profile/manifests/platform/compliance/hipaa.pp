class profile::platform::compliance::hipaa {

  case $::osfamily {
    'windows': { include ::profile::platform::compliance::hipaa::windows }
    default: {
      fail('Unsupported OS')
    }
  }
}
