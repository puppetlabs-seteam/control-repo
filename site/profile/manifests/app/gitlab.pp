class profile::app::gitlab {

  firewall { '100 allow gitlab https':
    proto  => 'tcp',
    dport  => '443',
    action => 'accept',
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

  class { 'gitlab':
    external_url => "https://${trusted[certname]}",
    require      => [
      File["/etc/gitlab/ssl/${trusted[certname]}.key"],
      File["/etc/gitlab/ssl/${trusted[certname]}.key"],
    ],
  }

  contain gitlab
}
