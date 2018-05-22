#
class profile::app::sensu::client (
  String $rabbitmq_user,
  String $rabbitmq_password,
  String $rabbitmq_vhost,
  String $rabbitmq_host,
  Array[String] $subscriptions,
){

  include profile::app::sensu::plugins

  Host  <<| tag == 'sensu-server' |>>

  class { '::sensu':
    rabbitmq_user     => $rabbitmq_user,
    rabbitmq_password => $rabbitmq_password,
    rabbitmq_vhost    => $rabbitmq_vhost,
    rabbitmq_host     => $rabbitmq_host,
    client            => true,
    subscriptions     => $subscriptions,
  }

}
