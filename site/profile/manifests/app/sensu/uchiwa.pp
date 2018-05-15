#
class profile::app::sensu::uchiwa (
  String $username,
  String $password,
  String $port,
){

  class { '::uchiwa':
    install_repo => false,
    user         => $username,
    pass         => $password,
    port         => $port,
  }

}
