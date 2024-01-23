class profile::app::rgbank (
  $db_password,
) {

  if $facts['os']['family'] != 'RedHat' {
    fail('Unsupported OS')
  }

  require ::profile::app::rgbank::db
  require ::profile::app::rgbank::webhead

  rgbank::db {'default':
    user     => 'rgbank',
    password => $db_password,
  }

  rgbank::web {'default':
    db_name     => 'rgbank-default',
    db_host     => 'localhost',
    db_user     => 'rgbank',
    db_password => $db_password,
    listen_port => 8888,
  }

  $default = {
    'host' => $facts['networking']['fqdn'],
    'port' => 8888,
    'ip'   => '127.0.0.1',
  }

  rgbank::load {'default':
    balancermembers => [ $default, ],
  }


}
