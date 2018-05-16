# rgbank loadbalancer profile
#
class profile::app::rgbank::load (
  $split = false,
) {

  include ::profile::platform::baseline

  if $split {
    
    # we have a separate load balancer, 
    # collect exported haproxy balancermember resources
    
    Haproxy::balancermember <<| |>>

    rgbank::load {'default':
      balancermembers => [ ],
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
