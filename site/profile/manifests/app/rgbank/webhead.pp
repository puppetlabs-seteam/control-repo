# rgbank webserver profile
class profile::app::rgbank::webhead(
  $dbhost = 'localhost',
  $split  = false,
) {

  class {'::profile::app::webserver::nginx':
    php => true,
  }

  file { 'default-nginx-disable':
    ensure  => absent,
    path    => '/etc/nginx/conf.d/default.conf',
    require => Package['nginx'],
    notify  => Service['nginx'],
  }

  include ::profile::app::db::mysql::client

  rgbank::web {'default':
    db_name     => 'rgbank-default',
    db_host     => 'localhost',
    db_user     => 'rgbank',
    db_password => 'rgbank',
    listen_port => 8888,
  }

}
