#
# Sample IIS Website managed by Puppet for Windows nodes
#
# @param doc_root
#    Document Root location on disk
# @param webserver_port
#    Server access port for web traffic.
# @param app_pool
#    Application Pool Name
# @param website_source_dir
#    Source location for content files
class profile::app::sample_website::windows (
  String  $doc_root           = 'C:\inetpub\wwwroot\sample_website',
  Integer $webserver_port     = 80,
  String  $app_pool           = 'sample_website',
  String  $website_source_dir = 'puppet:///modules/profile/app/sample_website',
) {
  # Include the main IIS webserver management classification
  class { 'profile::app::webserver::iis':
    default_website => false,
  }

  # Create the Application Pool for the Website
  iis_application_pool { 'sample_website':
    require => [
      Class['profile::app::webserver::iis'],
    ],
  }

  # Set the desired configuration for the Website
  iis_site { 'sample_website':
    ensure          => 'started',
    physicalpath    => $doc_root,
    applicationpool => $app_pool,
    bindings        => [
      {
        'bindinginformation' => "*:${webserver_port}:",
        'protocol'           => 'http',
      },
    ],
    require         => [
      Iis_application_pool['sample_website']
    ],
  }

  # Configure the doc_root folder for the Website
  file { $website_source_dir:
    ensure  => directory,
    path    => $doc_root,
    source  => $website_source_dir,
    recurse => true,
  }

  # Manage the index.html file on the Website using a provided Puppet EPP template.
  file { "${doc_root}/index.html":
    ensure  => file,
    content => epp('profile/app/sample_website.html.epp'),
  }

  # Add a firewall rule to permit access to the Website Port
  profile::firewall_open_port('IIS','tcp',$webserver_port,'Inbound rule for HTTP Server')
}
