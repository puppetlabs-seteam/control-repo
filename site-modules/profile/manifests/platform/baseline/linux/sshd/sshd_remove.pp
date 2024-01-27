# Class to disable openssh-server and remove associated packages
class profile::platform::baseline::linux::sshd::sshd_remove {
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
