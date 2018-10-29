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
    require      => [
      File["/etc/gitlab/ssl/${trusted[certname]}.key"],
      File["/etc/gitlab/ssl/${trusted[certname]}.key"],
    ],
  }

  file { ['/etc/gitlab', '/etc/gitlab/ssl'] :
    ensure => directory,
  }

  file { "/etc/gitlab/ssl/${trusted[certname]}.key" :
    ensure => file,
    source => "${::settings::privatekeydir}/${trusted[certname]}.pem",
    notify => Exec['gitlab_reconfigure'],
  }

  file { "/etc/gitlab/ssl/${trusted[certname]}.crt" :
    ensure => file,
    source => "${::settings::certdir}/${trusted[certname]}.pem",
    notify => Exec['gitlab_reconfigure'],
  }

  contain gitlab
}
