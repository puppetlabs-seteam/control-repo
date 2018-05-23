#
class profile::app::sensu::server (
  String $rabbitmq_user,
  String $rabbitmq_password,
  String $rabbitmq_vhost,
  String $rabbitmq_host,
  Array[String] $subscriptions,
){

  include ::profile::app::rabbitmq
  include ::profile::app::redis

  @@host { $facts['fqdn'] :
    ip           => $facts['ipaddress'],
    host_aliases => ['sensu-server.pdx.puppet.vm','sensu-server'],
    tag          => 'sensu-server',
  }
  Host  <<| tag == 'sensu-server' |>>

  class { '::sensu':
    rabbitmq_user     => $rabbitmq_user,
    rabbitmq_password => $rabbitmq_password,
    rabbitmq_vhost    => $rabbitmq_vhost,
    rabbitmq_host     => $rabbitmq_host,
    server            => true,
    api               => true,
    subscriptions     => $subscriptions,
    require           => Rabbitmq_user_permissions["${rabbitmq_user}@${rabbitmq_vhost}"],
  }

  rabbitmq_user { $rabbitmq_user:
    admin    => true,
    password => $rabbitmq_password,
    require  => Class['rabbitmq'],
  }

  rabbitmq_vhost { $rabbitmq_vhost:
    ensure  => present,
    require => Rabbitmq_user[$rabbitmq_user],
  }

  rabbitmq_user_permissions { "${rabbitmq_user}@${rabbitmq_vhost}":
    configure_permission => '.*',
    read_permission      => '.*',
    write_permission     => '.*',
    require              => Rabbitmq_user[$rabbitmq_user],
  }

  class { '::uchiwa':
    user         => $rabbitmq_user,
    pass         => $rabbitmq_password,
    port         => 3000,
    install_repo => false,
    require      => Class['::sensu']
  }

  firewall { '3000 allow Sensu Uchiwa access':
      dport  => '3000',
      proto  => tcp,
      action => accept,
  }

}
