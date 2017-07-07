class profile::platform::baseline {

  case $::kernel {
    'windows': {
      include ::profile::platform::baseline::windows
    }
    'Linux':   {
      include ::profile::platform::baseline::linux
    }
    default: {
      fail('Unsupported operating system!')
    }
  }

}
