class profile::app::puppet_webapp::webhead (
  $app_name    = 'webui',
  $app_version = '0.1.12',
  $dist_file   = "https://github.com/ipcrm/puppet_webapp/releases/download/${app_version}/puppet_webapp-${app_version}.tar.gz",
  $vhost_name  = $::fqdn,
  $vhost_port  = '8008',
  $doc_root    = '/var/www/flask',
  $app_env     = pick_default($::appenv,'dev')
) {

  $options = {
    app_name    => $app_name,
    app_version => $app_version,
    dist_file   => $dist_file,
    vhost_name  => $vhost_name,
    vhost_port  => $vhost_port,
    doc_root    => $doc_root,
    app_env     => $app_env,
  }

  case $::osfamily {

    'Debian': {
      class {'::profile::app::puppet_webapp::webhead::ubuntu':
        * => $options,
      }
    }

    'RedHat': {
      class {'::profile::app::puppet_webapp::webhead::rhel':
        * => $options,
      }
    }

    default: {
      fail('Unsupported OS')
    }

  }
}
