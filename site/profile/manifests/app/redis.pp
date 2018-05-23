# install redis
class profile::app::redis (
  String $bind,
){
  require epel
  class { 'redis':
    bind    => $bind,
    require => Class['::epel']
  }

  firewall { '6379 allow redis access':
      dport  => '6379',
      proto  => tcp,
      action => accept,
  }
}
