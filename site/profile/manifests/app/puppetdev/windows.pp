class profile::app::puppetdev::windows {

  package { 'Puppet Development Kit':
    ensure   => present,
    source   => 'https://puppet-pdk.s3.amazonaws.com/pdk/1.2.1.0/repos/windows/pdk-1.2.1.0-x64.msi',
    provider => 'windows',
  }

  ensure_packages('git', { ensure => present, provider => 'chocolatey' })

  windows_env { 'PATH=C:\Program Files\Puppet Labs\DevelopmentKit\private\ruby\2.1.9\bin': require => Package['Puppet Development Kit'] }

}
