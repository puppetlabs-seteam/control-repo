#
class profile::platform::baseline::linux::ssh () {
  # Determine the type of node which will drive which settings are applied
  case $facts['certname'] {
    /^.*(cd4pe|comply).*/: { $node_type = 'puppet_application_manager' }
    /^puppet.*/: { $node_type = 'puppet_server' }
    /^.*gitlab.*/: { $node_type = 'gitlab' }
    /^.*(rhel|ubu|nix).*$/, default: { $node_type = 'generic' }
  }

  case $node_type {
    'generic',default: {
      # Disable and remove SSH Server to reduce attack vectors on generic servers.
      # We don't need SSH server services when managing with Puppet.
      if !defined(Class['cem_linux']) {
        include profile::platform::baseline::linux::sshd::sshd_remove
      } else {
        if $facts['os']['name'] == 'RedHat' {
          package { 'openssh-server':
            ensure => present,
            before => [
              Service['sshd'],
              Class['cem_linux'],
              File_line['remove_sysconfig_openssh_crypto_policies']
            ],
          }
        }
        else {
          package { 'openssh-server':
            ensure => present,
            before => [Service['sshd'],Class['cem_linux']],
          }
        }
      }
    }
    'puppet_server','puppet_application_manager','gitlab': {
      include profile::platform::baseline::linux::sshd::sshd_lockdown
    }
  }
}
