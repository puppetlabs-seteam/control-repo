#
class profile::app::sample_website::windows (
    $doc_root,
    $webserver_port,
    $website_source_dir  = 'puppet:///modules/profile/sample_website',
) {
  require profile::app::sample_website::iis

  # configure iis
  iis::manage_app_pool {'sample_website':
    require => [
      Iis::Manage_site['Default Web Site'],
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
    content => epp('profile/sample_website/index.html.epp'),
  }

}
