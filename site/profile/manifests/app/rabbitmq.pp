# install rabbitmq
class profile::app::rabbitmq {

  include packagecloud
  include profile::app::redis

  packagecloud::repo { 'rabbitmq/rabbitmq-server':
    type    => 'rpm',
    require => Class['packagecloud']
  }

  packagecloud::repo { 'rabbitmq/erlang':
    type    => 'rpm',
    require => Class['packagecloud']
  }

  class { 'rabbitmq':
    require => [
                Class['redis'],
                Class['packagecloud'],
              ],
  }

  package { 'erlang':
    ensure => 'installed'
  }

}
