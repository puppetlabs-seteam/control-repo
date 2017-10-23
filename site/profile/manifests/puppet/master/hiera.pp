class profile::puppet::master::hiera {
  # Most Hiera configuration is handled by the environment's hiera.yaml. This
  # configuration exists only to manage the global data layer.

  $classifer_data_level = {
    name      => 'Classifier Configuration Data',
    data_hash => 'classifier_data',
  }

  $global_yaml_level = {
    name      => 'Global Yaml Data',
    data_hash => 'yaml_data',
    datadir   => '/etc/puppetlabs/code/data',
    path      => 'global.yaml',
  }

  # Include classifier in the hierarchy IF the PE version is new enough
  $hiera5_hierarchy = (versioncmp($facts['pe_server_version'], '2017.3.0') >= 0) ? {
    true  => [$classifer_data_level, $global_yaml_level],
    false => [$global_yaml_level],
  }

  # Configure either Hiera 5 or Hiera 3 depending on the PE version
  if (versioncmp($facts['pe_server_version'], '2017.2.1') >= 0) {
    # PE 2017.2.1 introduced Hiera 5.
    class { 'hiera':
      hiera_version        => '5',
      hierarchy            => $hiera5_hierarchy,
      eyaml                => true,
      manage_eyaml_package => true,
      provider             => 'puppetserver_gem',
    }

  } else {
    # Older versions of PE only support Hiera 3
    class { 'hiera':
      hiera_version        => '3',
      eyaml                => true,
      manage_eyaml_package => true,
      eyaml_extension      => '.yaml',
      provider             => 'puppetserver_gem',
      merge_behavior       => 'deeper',
      datadir              => '/etc/puppetlabs/code/environments/%{environment}/data',
      eyaml_datadir        => '/etc/puppetlabs/code/environments/%{environment}/data',
      notify               => Service['pe-puppetserver'],
      hierarchy            => [
        'nodes/%{fqdn}',
        'location/%{location}/%{role}',
        'role/%{tier}/%{role}',
        'role/%{role}',
        'location/%{location}',
        'common',
      ],
    }

  }

}
