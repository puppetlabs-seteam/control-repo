class profile::puppet::master::fileserver (
  $user  = 'root',
  $group = 'root',
) {

  class { '::profile::app::webserver::apache':
    default_vhost => false,
  }

  ensure_resource('file', '/opt/tse-files', { 'ensure' => 'directory', 'owner' => $user, 'group' => $group})

  apache::vhost { 'fileserver':
    vhost_name    => '*',
    port          => '81',
    docroot       => '/opt/tse-files',
    priority      => '10',
    docroot_owner => $user,
    docroot_group => $group,
  }

  firewall { '110 apache allow all':
    dport  => '81',
    chain  => 'INPUT',
    proto  => 'tcp',
    action => 'accept',
  }

  include ::profile::puppet::master::fileserver::jdk
  include ::profile::puppet::master::fileserver::tomcat

}
