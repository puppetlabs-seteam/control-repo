class profile::app::webserver::apache (
  $default_vhost = true,
){

  class { '::apache':
    default_vhost => $default_vhost,
  }

}
