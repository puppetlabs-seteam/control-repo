class profile::platform::baseline::linux::ssh () {

  if !defined(Class['ssh']){
    class{'::ssh':
      purge_keys => false
    }
  }

  firewall { '100 ssh allow all':
    dport  => '22',
    chain  => 'INPUT',
    proto  => 'tcp',
    action => 'accept',
  }

}
