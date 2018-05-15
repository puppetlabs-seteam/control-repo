#
class profile::app::sensu::client (
  String $rabbitmq_host,
  String $rabbitmq_vhost,
  String $rabbitmq_user,
  String $rabbitmq_password,
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
