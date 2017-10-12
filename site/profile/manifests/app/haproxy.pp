class profile::app::haproxy {

  if $::kernel == 'windows' {
    fail('Unsupported OS')
  }

  # Use at least 1.5 on all platforms
  if $::facts['os']['name'] == 'Ubuntu' {

    include ::apt

    apt::ppa { 'ppa:vbernat/haproxy-1.5':
      package_manage => true,
    }

  }

  package {'socat':
    ensure => present,
  }

  class { '::haproxy':
    global_options   => {
      'log'     => "${::ipaddress} local0",
      'chroot'  => '/var/lib/haproxy',
      'pidfile' => '/var/run/haproxy.pid',
      'maxconn' => '4000',
      'user'    => 'haproxy',
      'group'   => 'haproxy',
      'daemon'  => '',
      'stats'   => 'socket /var/lib/haproxy/stats level admin',
    },
    defaults_options => {
      'log'     => 'global',
      'stats'   => 'enable',
      'option'  => [
        'redispatch',
      ],
      'retries' => '3',
      'timeout' => [
        'http-request 10s',
        'queue 1m',
        'connect 10s',
        'client 1m',
        'server 1m',
        'check 10s',
      ],
      'maxconn' => '8000',
    },
  }

}
