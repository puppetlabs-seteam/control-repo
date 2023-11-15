#
class profile::platform::baseline::linux::ssh () {
  if !defined(Class['ssh']) {
    class { 'ssh':
      purge_keys => false,
    }
  }
}
