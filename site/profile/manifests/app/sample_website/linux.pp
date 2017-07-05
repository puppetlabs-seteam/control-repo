class profile::app::sample_website::linux (
    $doc_root = '/var/www/generic_website',
    $webserver_port = '80',
    $website_source_dir  = 'puppet:///modules/profile/sample_website',
) {
  
  require profile::app::sample_website::apache
  include firewalld

  # configure apache
  apache::vhost { $::fqdn:
    port    => $webserver_port,
    docroot => $doc_root,
    require => File[$doc_root],
  }

  firewalld_port { 'Open port for web':
    ensure   => present,
    zone     => 'public',
    port     => $webserver_port,
    protocol => 'tcp',
  }

  file { $website_source_dir:
    ensure  => directory,
    owner   => $::apache::user,
    group   => $::apache::group,
    mode    => '0755',
    path    => $doc_root,
    source  => $website_source_dir,
    recurse => true,
  }

  file { "${doc_root}/index.html":
    ensure  => file,
    content => epp('profile/sample_website/index.html.epp'),
  }

}
