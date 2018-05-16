class profile::app::rgbank {

  if $::osfamily != 'RedHat' {
    fail('Unsupported OS')
  }

  require ::profile::app::rgbank::db
  require ::profile::app::rgbank::webhead

  $default = {
    'host' => $::fqdn,
    'port' => 8888,
    'ip'   => '127.0.0.1',
  }

  rgbank::load {'default':
    balancermembers => [ $default, ],
  }


}
