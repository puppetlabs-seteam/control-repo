class profile::puppet::master::autosign {
  ini_setting { 'autosign':
    ensure  => present,
    path    => $settings::config,
    section => 'master',
    setting => 'autosign',
    value   => true,
    notify  => Service['pe-puppetserver'],
  }
}
