class profile::splunk::fileserver {
  include 'stdlib'

  # Detect Vagrant
  case $::virtual {
    'virtualbox': {
      $admin_file_owner = 'vagrant'
      $admin_file_group = 'vagrant'
    }
    default: {
      $admin_file_owner = 'root'
      $admin_file_group = 'root'
    }
  }

  apache::vhost { 'tse-files':
    vhost_name    => '*',
    port          => '8118',
    docroot       => '/opt/tse-files',
    priority      => '10',
    docroot_owner => $admin_file_owner,
    docroot_group => $admin_file_group,
  }

  
  class { 'apache':
    default_vhost => false,
  }


  # The *::finalize class includes some configuration that should be applied
  # after everything is up and fully operational. Some of this configuration is
  # used to signal to external watchers that the master is fully configured and
  # ready.
  class { 'profile::splunk::fileserver::finalize':
    stage => 'deploy_app',
  }

}
