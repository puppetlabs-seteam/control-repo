class profile::puppet::master {

  if $::facts['kernel'] != 'Linux' {
    fail('Unsupported OS!')
  }

  include ::profile::puppet::master::gogs
  include ::profile::puppet::master::autosign
  include ::profile::puppet::master::fileserver
  include ::profile::puppet::master::firewall
  include ::profile::puppet::master::hiera
  #include ::profile::puppet::master::node_manager

  firewall { '100 allow Puppet master access':
    dport  => '8140',
    proto  => tcp,
    action => accept,
  }
  
  firewall { '100 allow Puppet code manager access':
    dport  => '8170',
    proto  => tcp,
    action => accept,
  }


  firewall { '100 allow Puppet orch access':
    dport  => '8142',
    proto  => tcp,
    action => accept,
  }

  firewall { '100 allow Puppet client-tools access':
    dport  => '8143',
    proto  => tcp,
    action => accept,
  }

  firewall { '100 allow ActiveMQ MCollective access':
    dport  => '61614',
    proto  => tcp,
    action => accept,
  }

  firewall { '100 allow PE RBAC API access':
    dport  => '4433',
    proto  => tcp,
    action => accept,
  }

  firewall { '100 allow PE Console access':
      dport  => '443',
      proto  => tcp,
      action => accept,
  }

}
