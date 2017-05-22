class profile::app::tse_master::node_manager {

  $gitlab_server = 'gitlab.inf.puppet.vm'
  $jenkins_server = 'jenkins.inf.puppet.vm'

  package { 'puppetclassify':
    ensure   => present,
    provider => puppet_gem,
  }

  Node_group {
    require => Package['puppetclassify'],
  }

  # GENERAL PURPOSE
  # Node Groups ready to go out of the box. Not tied to any specific demo, but
  # potentially useful for demonstrating the Node Manager in general.

  node_group { 'PE Master':
    ensure               => present,
    environment          => 'production',
    override_environment => false,
    parent               => 'PE Infrastructure',
    rule                 => ['or', ['=', 'name', $::clientcert]],
    classes              => {
      'ldap'                                             => {},
      'ntp'                                              => {},
      'pe_repo'                                          => {},
      'pe_repo::platform::el_6_x86_64'                   => {},
      'pe_repo::platform::el_7_x86_64'                   => {},
      'pe_repo::platform::ubuntu_1404_amd64'             => {},
      'pe_repo::platform::windows_x86_64'                => {},
      'puppet_enterprise::profile::master'               => {
        'code_manager_auto_configure' => true,
        'r10k_remote'                 => "git@${gitlab_server}:puppet/control-repo.git",
        'r10k_private_key'            => '/etc/puppetlabs/puppetserver/ssh/id-control_repo.rsa' },
      'puppet_enterprise::profile::master::mcollective'  => {},
      'puppet_enterprise::profile::mcollective::peadmin' => {},
      'role::master'                                     => {},
      'profile::vim'                                     => { 'colorscheme' => 'elflord' },
    },
  }

  node_group { 'PE Agent':
    ensure               => 'present',
    classes              => {'puppet_enterprise::profile::agent' => {'package_inventory_enabled' => true}},
    environment          => 'production',
    override_environment => 'false',
    parent               => 'All Nodes',
    rule                 => ['and', ['~', ['fact', 'aio_agent_version'], '.+']],
  }

  node_group { 'Gitlab Server':
    ensure               => present,
    environment          => 'production',
    override_environment => false,
    parent               => 'All Nodes',
    rule                 => ['or', ['=', 'name', "${gitlab_server}"]],
    classes              => {
      'profile::gitlab' => {},
    },
  }

  node_group { 'Jenkins Server':
    ensure               => present,
    environment          => 'production',
    override_environment => false,
    parent               => 'All Nodes',
    rule                 => ['or', ['=', 'name', "${jenkins_server}"]],
    classes              => {
      'role::jenkins' => {},
    },
  }

  node_group { 'Linux Servers':
    ensure               => present,
    environment          => 'production',
    override_environment => false,
    parent               => 'All Nodes',
    rule                 => ['and',
      ['not', ['=', ['fact', 'name'], $::clientcert]],
      ['=', ['fact', 'kernel'], 'Linux'],
    ],
    classes              => {
      'ntp'                      => {},
      'profile::puppet::rootenv' => {},
      'profile::repos'           => { 'offline' => false },
      'profile::vim'             => { 'colorscheme' => 'elflord' },
    },
  }

  node_group { 'Windows Servers':
    ensure               => present,
    environment          => 'production',
    override_environment => false,
    parent               => 'All Nodes',
    rule                 => ['and', ['=', ['fact', 'kernel'], 'windows']],
    classes              => {
      'profile::windows::chocolatey' => {},
    },
  }

  node_group { 'PE MCollective':
    ensure               => present,
    environment          => 'production',
    override_environment => false,
    parent               => 'PE Infrastructure',
    rule                 => ['and',
      ['=', ['fact', 'is_admin'], 'true'],
      ['~', ['fact', 'aio_agent_version'], '.+'],
    ],
    classes              => {
      'puppet_enterprise::profile::mcollective::agent' => {},
    },
  }

  # RGBANK DEMO
  # Node groups and rbac users specific to the rgbank demo.

  rbac_user { 'joe':
    ensure       => 'present',
    name         => 'joe',
    display_name => 'Joe Black',
    email        => 'joe@puppetlabs.com',
    password     => 'puppetlabs',
  }

  node_group { 'rgbank':
    ensure      => 'present',
    environment => 'production',
    parent      => 'All Nodes',
    classes     => {},
    rule        => ['and',
      ['~', 'name', '^rgbank-.*'],
    ],
  }

  node_group { 'rgbank load balancers':
    ensure      => 'present',
    environment => 'production',
    parent      => 'rgbank',
    rule        => ['or',
      ['~', 'name', '^rgbank-loadbalancer-.*'],
      ['~', 'name', '^rgbank-dev.*'],
    ],
    classes     => {
      'role::rgbank::loadbalancer'   => {},
    }
  }

  node_group { 'rgbank app servers':
    ensure      => 'present',
    environment => 'production',
    parent      => 'rgbank',
    rule        => ['or',
      ['~', 'name', '^rgbank-appserver-.*'],
      ['~', 'name', '^rgbank-dev.*'],
    ],
    classes     => {
      'role::rgbank::app' => {},
    },
  }

  node_group { 'rgbank database servers':
    ensure      => 'present',
    environment => 'production',
    parent      => 'rgbank',
    rule        => ['or',
      ['~', 'name', '^rgbank-database-.*'],
      ['~', 'name', '^rgbank-dev.*'],
    ],
    classes     => {
      'role::rgbank::database' => {},
    },
  }

}
