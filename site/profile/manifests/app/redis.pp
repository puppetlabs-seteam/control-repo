# install redis
class profile::app::redis (
  String $bind,
){

  class { '::redis':
    bind    => $bind,
    require => Class['::epel']
  }
}
