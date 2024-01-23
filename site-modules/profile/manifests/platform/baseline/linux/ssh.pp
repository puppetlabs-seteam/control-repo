#
class profile::platform::baseline::linux::ssh () {
  # Disable and remove SSH Server to reduce attack vectors.
  # We don't need SSH server services when managing with Puppet.
  case $facts['os']['name'] {
    'CentOS': {
      service { 'sshd': ensure => stopped, enable => false, }
      -> package { 'OpenLogicEnv': ensure => absent, }
      -> package { 'azure-repo-svc': ensure => absent, }
      -> package { 'WALinuxAgent': ensure => absent, }
      -> package { 'openssh-server': ensure => absent, }
    }
    default: {
      service { 'sshd': ensure => stopped, enable => false, }
      -> package { 'openssh-server': ensure => absent, }
    }
  }
}
