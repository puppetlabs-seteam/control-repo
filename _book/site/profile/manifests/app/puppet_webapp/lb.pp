class profile::app::puppet_webapp::lb (
  $dev_hostname = 'devapp.puppet.vm',
  $prod_hostname = 'prodapp.puppet.vm',
){

  require ::profile::app::haproxy

  haproxy::mapfile { 'domains-to-backends':
    ensure   => 'present',
    mappings => [
      { $dev_hostname  => 'dev_bk' },
      { $prod_hostname => 'prod_bk' },
    ],
  }

  haproxy::frontend { 'allapps':
    ipaddress => '0.0.0.0',
    ports     => '80',
    mode      => 'http',
    options   => {
      'use_backend' => [
        "dev_bk if { hdr(Host) -i ${dev_hostname} }",
        "prod_bk if { hdr(Host) -i ${prod_hostname} }",
      ],
    },
  }

  haproxy::backend { 'dev_bk':
    mode    => 'http',
    options => {
      'option'  => [
        'tcplog',
      ],
      'balance' => 'roundrobin',
    },
  }

  haproxy::backend { 'prod_bk':
    mode    => 'http',
    options => {
      'option'  => [
        'tcplog',
      ],
      'balance' => 'roundrobin',
    },
  }

  Haproxy::Balancermember <<| listening_service == 'dev_bk' |>>
  Haproxy::Balancermember <<| listening_service == 'prod_bk' |>>

  firewall { '111 allow http 80 access':
    dport  => 80,
    proto  => tcp,
    action => accept,
  }

}
