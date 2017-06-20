class profile::app::sample_website::windows (
  String $doc_root           = 'C:\inetpub\wwwroot\sample_website',
  Integer $webserver_port    = 80,
  String $website_source_dir = 'puppet:///modules/profile/app/sample_website'
) {

  class{'::profile::app::webserver::iis':
    default_website => false,
  }

  # configure iis
  iis::manage_app_pool {'sample_website':
    require => [
      Class['::profile::app::webserver::iis'],
    ],
  }

  iis::manage_site { $::fqdn:
    site_path  => $doc_root,
    port       => $webserver_port,
    ip_address => '*',
    app_pool   => 'sample_website',
    require    => [
      Iis::Manage_app_pool['sample_website']
    ],
  }

  windows_firewall::exception { 'IIS':
    ensure       => present,
    direction    => 'in',
    action       => 'Allow',
    enabled      => 'yes',
    protocol     => 'TCP',
    local_port   => $webserver_port,
    display_name => 'HTTP Inbound',
    description  => 'Inbound rule for HTTP Server',
  }

  file { $website_source_dir:
    ensure  => directory,
    path    => $doc_root,
    source  => $website_source_dir,
    recurse => true,
  }

  file { "${doc_root}/index.html":
    ensure  => file,
    content => epp('profile/app/sample_website.html.epp'),
  }

}
