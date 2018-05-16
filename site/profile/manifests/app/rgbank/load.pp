# rgbank loadbalancer profile
#
class profile::app::rgbank::load {

  $default = {
    'host' => $::fqdn,
    'port' => 8888,
    'ip'   => '127.0.0.1',
  }

  rgbank::load {'default':
    balancermembers => [ $default, ],
  }

}
