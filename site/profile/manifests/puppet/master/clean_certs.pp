# A class to clean up certs
class profile::puppet::master::clean_certs {

  exec{ 'purge-master-cert':
    path    => $::path,
    command => "puppet node purge ${::fqdn}",
    onlyif  => "puppet cert list ${::fqdn} &>/dev/null",
  }

  #Stop PE Services
  $pe_services = [
    'puppet',
    'pe-puppetserver',
    'pe-activemq',
    'mcollective',
    'pe-puppetdb',
    'pe-postgresql',
    'pe-console-services',
    'pe-nginx',
    'pe-orchestration-services',
    'pxp-agent'
  ]

  File {
    require => Service[$pe_services],
  }

  service { $pe_services:
    ensure => stopped,
    enable => false,
  }

  file { '/etc/puppetlabs/puppet/ssl':
    ensure  => absent,
    recurse => true,
    purge   => true,
    force   => true,
  }

  file { '/etc/puppetlabs/puppetdb/ssl':
    ensure  => absent,
    recurse => true,
    purge   => true,
    force   => true,
  }

  file { '/opt/puppetlabs/puppet/cache/client_data/catalog/localhost.localdomain.json':
    ensure => absent,
  }

  file { '/opt/puppetlabs/server/data/postgresql/9.4/data/certs':
    ensure  => absent,
    recurse => true,
    purge   => true,
    force   => true,
  }

  file { '/opt/puppetlabs/server/data/console-services/certs/':
    ensure  => absent,
    recurse => true,
    purge   => true,
    force   => true,
  }

  file {[
    '/etc/puppetlabs/nginx/conf.d/proxy.conf',
    '/etc/puppetlabs/console-services/conf.d/console.conf',
  ]:
    ensure => absent,
  }

  File <||>
    -> package {'pe-activemq':
      ensure    => absent,
    }

    file { '/etc/puppetlabs/activemq':
      ensure  => absent,
      recurse => true,
      purge   => true,
      force   => true,
    }

}
