class profile::platform::baseline::linux::ssh (
  String $permit_root_login = 'no',
) {

  if !defined(Class['ssh']){
    class{'::ssh':
      permit_root_login => $permit_root_login,
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
