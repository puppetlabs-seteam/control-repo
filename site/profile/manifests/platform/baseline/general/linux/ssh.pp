class profile::platform::baseline::general::linux::ssh (
  String $permit_root_login = 'yes',
) {

  class{'::ssh':
    permit_root_login => $permit_root_login,
  }

  firewall { '100 ssh allow all':
    dport  => '22',
    chain  => 'INPUT',
    proto  => 'tcp',
    action => 'accept',
  }

}
