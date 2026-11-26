#
# Sample Apache Website managed by Puppet for Linux nodes
#
# @param doc_root
#    Document root location on disk
# @param webserver_port
#    Server access port for web traffic.
# @param website_source_dir
#    Source location for content files
class profile::app::sample_website::linux (
  String  $doc_root           = '/var/www/html',
  Integer $webserver_port     = 80,
  String  $website_source_dir = 'puppet:///modules/profile/app/sample_website',
) {
  # Include the main Apache webserver management classification
  class { 'profile::app::webserver::apache':
    default_vhost  => false,
  }

  # Set the desired configuration for the Website Virtual Host
  apache::vhost { $facts['networking']['fqdn']:
    port            => $webserver_port,
    docroot         => $doc_root,
    require         => File[$doc_root],
    options         => ['-Indexes'],
    error_documents => [
      { 'error_code' => '404', 'document' => '/404.html' },
      { 'error_code' => '403', 'document' => '/403.html' },
    ],
  }

  # Configure the doc_root folder for the Website
  file { $website_source_dir:
    ensure  => directory,
    owner   => $apache::user,
    group   => $apache::group,
    mode    => '0755',
    path    => $doc_root,
    source  => $website_source_dir,
    recurse => true,
  }

  # Manage the index.html file on the Website using a provided Puppet EPP template.
  file { "${doc_root}/index.html":
    ensure  => file,
    content => epp('profile/app/sample_website.html.epp'),
  }

  # Manage the error files on the Website using a provided Puppet EPP template.
  ['403','404'].each | String $err_no | {
    file { "${doc_root}/${err_no}.html":
      ensure  => file,
      content => epp("profile/app/${err_no}.html.epp"),
    }
  }

  # Automatically open firewall port to allow access
  $firewall_type = profile::firewall_type($facts['os']['name'], $facts['os']['release']['major'])
  if $firewall_type == 'firewalld' {
    # The baseline is no longer applied, so install and start firewalld here before
    # opening the port. No purge options: existing zones, ports and rules are left alone.
    include firewalld
    profile::firewall_open_port('Website Access','tcp',$webserver_port,'Webserver Access')
    Class['firewalld'] -> Firewalld_port['Allow Website Access']
  } else {
    # Not a firewalld OS, so no firewalld_port: firewalld may not be installed here.
    # ufw/iptables nodes still get a rule of their own type; on an OS unknown to
    # profile::firewall_type, firewall_open_port only logs a warning.
    profile::firewall_open_port('Website Access','tcp',$webserver_port,'Webserver Access')
  }
}
