class profile::app::gitlab (
  Boolean $ssl = false,
) {

  if ($facts[kernel] != 'Linux') {
    fail('Unsupported OS')
  }

  case $ssl {
    default, false: {
      $protocol = 'http'
      $port     = '80'
    }
    true: {
      $protocol = 'https'
      $port     = '443'
    }
  }

  firewall { '100 allow gitlab':
    proto  => 'tcp',
    dport  => $port,
    action => 'accept',
  }

  class { 'gitlab':
    external_url => "${protocol}://${trusted[certname]}",
  }

  file { '/etc/gitlab/ssl':
    ensure => directory,
  }

  file { "/etc/gitlab/ssl/${trusted[certname]}.key" :
    ensure => file,
    source => "${::settings::privatekeydir}/${trusted[certname]}.pem",
    notify => Class['gitlab::service'],
  }

  file { "/etc/gitlab/ssl/${trusted[certname]}.crt" :
    ensure => file,
    source => "${::settings::certdir}/${trusted[certname]}.pem",
    notify => Class['gitlab::service'],
  }

  contain gitlab
}
