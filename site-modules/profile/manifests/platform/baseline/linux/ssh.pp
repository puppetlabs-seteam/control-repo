#
class profile::platform::baseline::linux::ssh () {
  if !defined(Class['ssh']) and !defined(Class['cem_linux']) {
    class { 'ssh':
      purge_keys => false,
    }
  }
}
