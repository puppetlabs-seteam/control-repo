#
# Main baseline class for all platforms
#
# @param orch_agent
#    Ensure parameter handed to the profile::puppet::orch_agent module
# @param timeservers
#    Array of time servers to use for NTP or Windown Time
#
class profile::platform::baseline (
  Boolean $orch_agent  = false,
  Array   $timeservers = ['0.pool.ntp.org','1.pool.ntp.org'],
) {
  ## Global baseline settings
  if !$facts['os']['name'] == 'RedHat' and !$facts['os']['version']['major'] >= 8 {
    class { 'time':
      servers => $timeservers,
    }
  }

  class { 'profile::puppet::orch_agent':
    ensure => $orch_agent,
  }

  ensure_resource('service','puppet', {
      ensure => 'running',
      enable => true,
  })

  include profile::platform::baseline::firewall

  ## Platform specific baselines settings
  case $facts['kernel'] {
    'windows': {
      include profile::platform::baseline::windows
    }
    'Linux':   {
      include profile::platform::baseline::linux
    }
    default: {
      fail("Kernel type '${facts['kernel']}' does not have an associated baseline profile.")
    }
  }
}
