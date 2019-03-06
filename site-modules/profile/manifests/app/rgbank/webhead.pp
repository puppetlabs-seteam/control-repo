class profile::app::rgbank::webhead {

  class{'::profile::app::webserver::nginx':
    php => true,
  }

  file { 'default-nginx-disable':
    ensure  => absent,
    path    => '/etc/nginx/conf.d/default.conf',
    require => Package['nginx'],
    notify  => Service['nginx'],
  }

  include ::profile::app::db::mysql::client

}
