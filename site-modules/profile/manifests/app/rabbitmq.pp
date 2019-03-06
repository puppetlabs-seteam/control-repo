# install rabbitmq
class profile::app::rabbitmq {

  include packagecloud
  packagecloud::repo { 'rabbitmq/rabbitmq-server':
    type    => 'rpm',
    require => Class['packagecloud']
  }

  packagecloud::repo { 'rabbitmq/erlang':
    type    => 'rpm',
    require => Class['packagecloud']
  }

  class { 'rabbitmq':
    package_ensure => 'latest',
    repos_ensure   => true,
    require        => [
                        Class['packagecloud'],
                        Package['erlang'],
                      ],
  }

  package { 'erlang':
    ensure  => 'latest',
    require => Packagecloud::Repo['rabbitmq/erlang']
  }

  firewall { '5672 allow rabbitmq access':
      dport  => '5672',
      proto  => tcp,
      action => accept,
  }

}
