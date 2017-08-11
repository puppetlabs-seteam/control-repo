class profile::platform::baseline (
  Boolean $orch_agent  = false,
  Array   $timeservers = ['0.pool.ntp.org','1.pool.ntp.org']
){

  # Global
  class {'::time':
    servers => $timeservers,
  }

  class {'::profile::puppet::orch_agent':
    ensure => $orch_agent,
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
