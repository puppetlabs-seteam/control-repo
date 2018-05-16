# rgbank webserver profile
class profile::app::rgbank::webhead(
  $dbhost = 'localhost',
  $split  = false,
) {

  include ::profile::platform::baseline

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

  if $split {
    @@haproxy::balancermember { $::fqdn:
      listening_service => "rgbank-default",
      server_names      => $::fqdn,
      ipaddresses       => $::ipaddress,
      ports             => 8888,
      options           => 'check verify none',
    }
  }

  rgbank::web {'default':
    db_name     => 'rgbank-default',
    db_host     => 'localhost',
    db_user     => 'rgbank',
    db_password => 'rgbank',
    listen_port => 8888,
  }

}
