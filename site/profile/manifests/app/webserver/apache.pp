class profile::app::webserver::apache (
  $default_vhost = true,
){

  if $::kernel == 'windows' {
    fail('Unsupported OS')
  }

  class { '::apache':
    default_vhost => $default_vhost,
  }

}
