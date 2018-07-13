# rgbank loadbalancer profile
#
class profile::app::rgbank::lb (
  $split = false,
) {

  include ::profile::platform::baseline

  class { 'selinux':
    mode => 'permissive',
    type => 'targeted',
  }

  if $split {

    # we have a separate load balancer, 
    # collect exported haproxy balancermember resources

    Haproxy::Balancermember <<| |>>

    rgbank::load {'default':
      balancermembers => [ ],
    }

    haproxy::listen { 'stats':
      collect_exported => false,
      ipaddress        => '0.0.0.0',
      mode             => 'http',
      ports            => '8080',
      options          => {
        'stats'  => [
          'enable',
          'uri /',
          'show-legends',
          'realm HAProxy\ Statistics',
          'auth haproxy:haproxy',
          'admin if TRUE',
        ],
      },
    }

    firewall { '8080 allow haproxy stats access':
      dport  => [8080],
      proto  => tcp,
      action => accept,
    }

  } else {

    # our webhead is on the same node
    # configure with default settings

    $default = {
      'host' => $::fqdn,
      'port' => 8888,
      'ip'   => '127.0.0.1',
    }

    rgbank::load {'default':
      balancermembers => [ $default, ],
    }
  }
}
