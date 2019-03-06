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

  # Determine if package_inventory is a thing in this version, should be greater or equal to 2017.2
  $base_ver  = split($::pe_server_version,'[.]')[0] + 0
  $minor_ver = split($::pe_server_version,'[.]')[1] + 0

  if $base_ver >= 2017 and $minor_ver >= 2 {

    node_group { 'PE Agent':
      ensure               => 'present',
      classes              => {'puppet_enterprise::profile::agent' => {'package_inventory_enabled' => true}},
      environment          => 'production',
      override_environment => false,
      parent               => 'All Nodes',
      rule                 => ['and', ['~', ['fact', 'aio_agent_version'], '.+']],
    }

  }

  node_group { 'SE Demo Env Conf':
      ensure               => 'present',
      environment          => 'production',
      override_environment => false,
      parent               => 'All Nodes',
  }

  node_group { 'SE Puppet role::seteam_puppet_master':
    ensure               => present,
    environment          => 'production',
    override_environment => false,
    parent               => 'SE Demo Env Conf',
    rule                 => ['or', ['=', 'name', $::clientcert]],
    classes              => {
      'pe_repo::platform::el_6_x86_64'       => {},
      'pe_repo::platform::el_7_x86_64'       => {},
      'pe_repo::platform::ubuntu_1404_amd64' => {},
      'pe_repo::platform::ubuntu_1604_amd64' => {},
      'pe_repo::platform::windows_x86_64'    => {},
      'role::seteam_puppet_master'           => {},
      'profile::puppet::master::se_gitbook'  => {},
    },
  }

  node_group { 'Windows Bootstrap':
    ensure               => present,
    environment          => 'production',
    override_environment => false,
    parent               => 'SE Demo Env Conf',
    rule                 => ['and', ['=', ['fact', 'kernel'], 'windows']],
    classes              => {
      'profile::platform::baseline::windows::bootstrap' => {},
      'profile::platform::baseline::windows::firewall'  => {},
    },
  }

}
