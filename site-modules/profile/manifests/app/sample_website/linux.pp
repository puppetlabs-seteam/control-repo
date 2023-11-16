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
  case $profile::platform::baseline::firewall::firewall_type {
    'iptables':  {
      firewall { '200 Allow Website access':
        dport => $webserver_port,
        proto => tcp,
        jump  => accept,
      }
    }
    'firewalld': {
      firewalld_port { 'Allow Website access':
        ensure   => present,
        zone     => 'public',
        port     => $webserver_port,
        protocol => 'tcp',
      }
    }
    'ufw':       {
      ufw_rule { 'Allow Website access':
        ensure       => present,
        action       => 'allow',
        direction    => 'in',
        interface    => undef,
        to_ports_app => $webserver_port,
        proto        => 'tcp',
      }
    }
    default:     {
      fail("Linux 'sample_website' module could not determine proper firewall type. Is 'profile::platform::baseline' applied?")
    }
  }
}
