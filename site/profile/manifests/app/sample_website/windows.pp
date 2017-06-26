class profile::app::sample_website::windows (
    $doc_root = 'C:\\inetpub\\wwwroot\\generic_website',
    $webserver_port = '80',
    $website_source_dir  = 'puppet:///modules/profile/sample_website',
) {
  require profile::app::sample_website::iis

  # configure iis
  iis_application_pool { 'sample_website':
    require => [
      Iis_site['Default Web Site'],
    ],
  }

  iis_site { $::fqdn:
    physicalpath    => $doc_root,
    port            => $webserver_port,
    bindings        => [
      {
        'bindinginformation'   => "*:${webserver_port}:",
      },
    ],
    require         => [
      Iis_application_pool['sample_website']
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
