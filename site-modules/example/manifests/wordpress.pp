class example::wordpress {
  include apache
  include apache::mod::php
  include mysql::server
  include mysql::bindings
  include mysql::bindings::php

  package { 'wget':
    ensure => present,
  }

  apache::vhost { $facts['networking']['fqdn']:
    priority   => '10',
    vhost_name => $facts['networking']['fqdn'],
    port       => '80',
    docroot    => '/var/www/html',
  }

  -> class { '::wordpress':
    install_dir => '/var/www/html',
  }

  firewall { '80 allow apache access':
      dport  => [80],
      proto  => tcp,
      action => accept,
  }
}
