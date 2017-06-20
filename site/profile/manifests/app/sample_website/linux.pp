class profile::app::sample_website::linux (
  String $doc_root = '/var/www/html',
  Integer $webserver_port = 80,
  String $website_source_dir = 'puppet:///modules/profile/app/sample_website'
) {

  class {'::profile::app::webserver::apache':
    default_vhost  => false,
    doc_root       => $doc_root,
    webserver_port => $webserver_port,
  }

  include ::firewalld

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
    content => epp('profile/app/sample_website.html.epp'),
  }

}
