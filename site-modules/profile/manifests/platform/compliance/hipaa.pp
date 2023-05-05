class profile::platform::compliance::hipaa {

  case $facts['os']['family'] {
    'windows': {
      include ::profile::platform::compliance::hipaa::windows
    }
    default: {
      include ::profile::platform::compliance::hipaa::linux
    }
  }
}
