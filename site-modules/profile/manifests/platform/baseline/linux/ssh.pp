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
      include profile::platform::baseline::linux::sshd::sshd_remove
    }
    'puppet_server','puppet_application_manager','gitlab': {
      include profile::platform::baseline::linux::sshd::sshd_locakdown
    }
  }
}
