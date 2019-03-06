class profile::app::rgbank {

  if $::osfamily != 'RedHat' {
    fail('Unsupported OS')
  }

  require ::profile::app::rgbank::db
  require ::profile::app::rgbank::webhead

  rgbank::db {'default':
    user     => 'rgbank',
    password => 'rgbank',
  }

  rgbank::web {'default':
    db_name     => 'rgbank-default',
    db_host     => 'localhost',
    db_user     => 'rgbank',
    db_password => 'rgbank',
    listen_port => 8888,
  }

  $default = {
    'host' => $::fqdn,
    'port' => 8888,
    'ip'   => '127.0.0.1',
  }

  rgbank::load {'default':
    balancermembers => [ $default, ],
  }


}
