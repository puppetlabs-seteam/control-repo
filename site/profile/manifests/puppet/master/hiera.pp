class profile::puppet::master::hiera {
  $cmdpath = [
    '/usr/local/sbin',
    '/usr/local/bin',
    '/usr/sbin',
    '/usr/bin',
    '/opt/puppetlabs/bin',
    '/sbin',
    '/opt/puppetlabs/puppet/bin'
  ]

  #Check if puppetserver service is defined, if so manage restart after updating hiera
  if defined(Service['pe-puppetserver']) {
    class {'::hiera':
      hierarchy       => [
        'nodes/%{fqdn}',
        'location/%{location}/%{role}',
        'role/%{tier}/%{role}',
        'role/%{role}',
        'location/%{location}',
        'common',
      ],
      eyaml           => true,
      logger          => 'console',
      confdir         => '/etc/puppetlabs/puppet',
      merge_behavior  => 'deeper',
      datadir         => '/etc/puppetlabs/code/environments/%{environment}/hieradata',
      eyaml_datadir   => '/etc/puppetlabs/code/environments/%{environment}/hieradata',
      provider        => puppetserver_gem,
      notify          => Service['pe-puppetserver'],
      cmdpath         => $cmdpath,
      eyaml_extension => '.yaml',
    }
  }
  else {
    class {'::hiera':
      hierarchy       => [
        'nodes/%{fqdn}',
        'location/%{location}/%{role}',
        'role/%{tier}/%{role}',
        'role/%{role}',
        'location/%{location}',
        'common',
      ],
      confdir         => '/etc/puppetlabs/puppet',
      eyaml           => true,
      logger          => 'console',
      merge_behavior  => 'deeper',
      datadir         => '/etc/puppetlabs/code/environments/%{environment}/hieradata',
      eyaml_datadir   => '/etc/puppetlabs/code/environments/%{environment}/hieradata',
      provider        => puppetserver_gem,
      cmdpath         => $cmdpath,
      eyaml_extension => '.yaml',
    }
  }

# Ensure that eyaml keys that have been generated are put into the puppet fileserver hosted here

  ensure_resource('file', '/opt/fileserver', { 'ensure' => 'directory', 'owner' => 'root', 'group' => 'root' })

  file { '/opt/fileserver/eyaml':
    ensure => 'directory',
  }

  file { '/opt/fileserver/eyaml/private_key.pkcs7.pem':
    ensure  => present,
    source  => '/etc/puppetlabs/puppet/keys/private_key.pkcs7.pem',
    require => File['/opt/fileserver'],
  }

  file { '/opt/fileserver/eyaml/public_key.pkcs7.pem':
    ensure  => present,
    source  => '/etc/puppetlabs/puppet/keys/public_key.pkcs7.pem',
    require => File['/opt/fileserver'],
  }

}
