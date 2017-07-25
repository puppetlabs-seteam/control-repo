class profile::puppet::master::firewall {

  # Puppet master firewall rules
  Firewall {
    chain  => 'INPUT',
    proto  => 'tcp',
    action => 'accept',
  }

  firewall { '110 puppetmaster allow all': dport  => '8140';  }
  firewall { '110 console allow all':      dport  => '443';   }
  firewall { '110 mcollective allow all':  dport  => '61613'; }
  firewall { '110 pxp orch allow all':     dport  => '8142';  }

}


