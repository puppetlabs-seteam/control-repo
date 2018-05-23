#
class profile::app::sensu::uchiwa (
  String $username,
  String $password,
  String $port,
){
  require ::profile::app::sensu::server
  class { '::uchiwa':
    install_repo => false,
    user         => $username,
    pass         => $password,
    port         => $port,
  }

  firewall { '3000 allow Sensu Uchiwa access':
      dport  => '3000',
      proto  => tcp,
      action => accept,
  }

}
