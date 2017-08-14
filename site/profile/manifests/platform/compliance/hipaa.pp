class profile::platform::compliance::hipaa {

  case $::osfamily {
    'windows': {
      include ::profile::platform::compliance::hipaa::windows
    }
    default: {
      include ::profile::platform::compliance::hipaa::linux
    }
  }
}
