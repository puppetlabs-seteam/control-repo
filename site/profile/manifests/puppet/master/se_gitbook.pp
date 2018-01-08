class profile::puppet::master::se_gitbook (
  $gitbook_port    = '4000',
  $gitbook_wwwroot = '/var/www/se_gitbook',
  $gitbook_source  = 'https://s3-us-west-2.amazonaws.com/tse-builds/gitbooks/',
  $gitbook_release = pick_default($::gitbook_file,'se_gitbook_latest.tar'),
  $gitbook_local   = '/etc/gitbooks',
) {

  file { $gitbook_local:
    ensure => directory,
    mode   => '0755',
  }

  file { $gitbook_wwwroot:
    ensure => directory,
    mode   => '0755',
  }

  remote_file { $gitbook_release:
    source => "https://s3-us-west-2.amazonaws.com/tse-builds/gitbooks/${gitbook_release}",
    path   => "${gitbook_local}/${gitbook_release}",
  }

  firewall { "150 allow http ${gitbook_port}  access":
    dport  => $gitbook_port,
    proto  => tcp,
    action => accept,
  }

  archive { "${gitbook_local}/${gitbook_release}":
    ensure       => present,
    extract      => true,
    extract_path => $gitbook_wwwroot,
    source       => "${gitbook_local}/${gitbook_release}",
    creates      => "${$gitbook_wwwroot}/index.html",
    cleanup      => true,
  }

  apache::vhost { $::fqdn:
    port    => $gitbook_port,
    docroot => $gitbook_wwwroot,
  }

}
