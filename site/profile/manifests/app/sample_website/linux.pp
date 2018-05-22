class profile::app::sample_website::linux (
  String $doc_root = '/var/www/html',
  Integer $webserver_port = 80,
  String $website_source_dir = 'puppet:///modules/profile/app/sample_website',
  Boolean $enable_monitoring = false,
) {

  if $enable_monitoring {
    sensu::subscription { 'apache': }
  }

  class {'::profile::app::webserver::apache':
    default_vhost  => false,
  }

  # configure apache
  apache::vhost { $::fqdn:
    port            => $webserver_port,
    docroot         => $doc_root,
    require         => File[$doc_root],
    options         => ['-Indexes'],
    error_documents => [
      { 'error_code' => '404', 'document' => '/404.html' },
      { 'error_code' => '403', 'document' => '/403.html' }
    ],
  }

  firewall { '100 allow http and https access':
    dport  => $webserver_port,
    proto  => tcp,
    action => accept,
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

  file { "${doc_root}/403.html":
    ensure  => file,
    content => epp('profile/app/403.html.epp'),
  }

  file { "${doc_root}/404.html":
    ensure  => file,
    content => epp('profile/app/404.html.epp'),
  }
}
