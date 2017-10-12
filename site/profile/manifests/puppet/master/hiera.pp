class profile::puppet::master::hiera {
  $cmdpath = [
    '/usr/local/sbin',
    '/usr/local/bin',
    '/usr/sbin',
    '/usr/bin',
    '/opt/puppetlabs/bin',
    '/sbin',
    '/opt/puppetlabs/puppet/bin',
  ]

    $base_ver  = split($::pe_server_version,'[.]')[0] + 0
    $minor_ver = split($::pe_server_version,'[.]')[1] + 0

    if $base_ver < 2017 or ($base_ver == 2017 and $minor_ver < 3) {
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
    } elsif $base_ver == 2017 and $minor_ver >= 3 {

      class { '::hiera':
        hiera_version   =>  '5',
        hiera5_defaults =>  {'datadir' => 'data', 'data_hash' => 'yaml_data'},
        hierarchy       =>  [
          {'name' =>  'Classifier Configuration Data', 'data_hash' => 'classifier_data' },
          {'name' =>  'Nodes  yaml',       'path' =>  'nodes/%{::fqdn}.yaml'},
          {'name' =>  'Location/Role yaml',     'path' =>  'location/%{::location}/%{::role}.yaml'},
          {'name' =>  'Role/Tier yaml',    'path' =>  'role/%{::tier}/%{::role}.yaml'},
          {'name' =>  'Role yaml',         'path' =>  'role/%{::role}.yaml'},
          {'name' =>  'Location yaml',     'path' =>  'location/%{::location}.yaml'},
          {'name' =>  'Default yaml file', 'path' =>  'common.yaml'},
        ],
        eyaml           => true,
        logger          => 'console',
        merge_behavior  => 'deeper',
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
