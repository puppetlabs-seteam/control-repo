class profile::puppet::orch_agent (
  Boolean $ensure = false,
)
{
  $puppet_conf = $::kernel ? {
    'windows' => 'C:/ProgramData/PuppetLabs/puppet/etc/puppet.conf',
    default   => '/etc/puppetlabs/puppet/puppet.conf',
  }

  $ensure_setting = $ensure ? {
    true  => 'present',
    false => 'absent',
  }

  ini_setting { 'puppet agent use_cached_catalog':
    ensure  => $ensure_setting,
    path    => $puppet_conf,
    section => 'agent',
    setting => 'use_cached_catalog',
    # lint:ignore:quoted_booleans
    value   => 'true',
    # lint:endignore
  }

}
