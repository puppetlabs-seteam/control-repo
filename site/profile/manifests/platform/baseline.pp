class profile::platform::baseline (
  $timeservers = ['0.pool.ntp.org','1.pool.ntp.org']
){

  # Global
  class {'::time':
    servers => $timeservers,
  }

  # OS Specific
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
