class profile::puppet::master::node_manager {

  package { 'puppetclassify':
    ensure   => present,
    provider => puppet_gem,
    notify   => Exec['refresh_classes'],
  }

  Node_group {
    require => Package['puppetclassify'],
  }

  exec{'refresh_classes':
    path        => $::path,
    command     => "/etc/puppetlabs/code/environments/${::environment}/scripts/refresh_classes.sh",
    refreshonly => true,
  }

  node_group { 'PE Agent':
    ensure               => 'present',
    classes              => {'puppet_enterprise::profile::agent' => {'package_inventory_enabled' => true}},
    environment          => 'production',
    override_environment => false,
    parent               => 'All Nodes',
    rule                 => ['and', ['~', ['fact', 'aio_agent_version'], '.+']],
  }

  node_group { 'role::master_server':
    ensure               => present,
    environment          => 'production',
    override_environment => false,
    parent               => 'All Nodes',
    rule                 => ['or', ['=', 'name', $::clientcert]],
    classes              => {
      'pe_repo::platform::el_6_x86_64'       => {},
      'pe_repo::platform::el_7_x86_64'       => {},
      'pe_repo::platform::ubuntu_1404_amd64' => {},
      'pe_repo::platform::ubuntu_1604_amd64' => {},
      'pe_repo::platform::windows_x86_64'    => {},
      'role::master_server'                  => {},
    },
  }

}
