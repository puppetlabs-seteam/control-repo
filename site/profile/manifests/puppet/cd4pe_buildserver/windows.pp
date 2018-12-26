# This class installs the necessary components to become a Distelli Buildserver
class profile::puppet::cd4pe_buildserver::windows
  {
  file { 'c:/tmp':
    ensure   => directory,
  }

  file { 'Puppet Development Kit download':
    ensure   => present,
    source   => 'https://puppet-pdk.s3.amazonaws.com/pdk/1.8.0.0/repos/windows/pdk-1.8.0.0-x64.msi',
    path     => 'c:/tmp/pdk-1.8.0.0-x64.msi',
    checksum => 'mtime',
    require  => File['c:/tmp'],
  }

  package { 'Puppet Development Kit':
    ensure   => present,
    source   => 'c:/tmp/pdk-1.8.0.0-x64.msi',
    provider => 'windows',
    require  => File['Puppet Development Kit download'],
  }

  ensure_packages(['Wget','git'], { ensure => present, provider => 'chocolatey' })

  # If this cacert isn't placed and used, ruby version managers will croak
  file { 'C:/cacert':
    ensure => directory,
    group  => 'Administrators',
  }

  file { 'Cacert File':
    ensure  => present,
    source  => 'http://curl.haxx.se/ca/cacert.pem',
    group   => 'Administrators',
    path    => 'C:/cacert/cacert.pem',
    require => File['C:/cacert'],
  }

  windows_env {'SSL_CERT_FILE':
    ensure    => present,
    variable  => 'SSL_CERT_FILE',
    value     => 'c:/cacert/cacert.pem',
    mergemode => clobber,
  }

  windows_env {'PATH':
    ensure    => present,
    variable  => 'PATH',
    value     => ['C:\Program Files\Puppet Labs\DevelopmentKit\private\ruby\2.4.4\bin', 'C:\Program Files\Amazon\cfn-bootstrap', 'C:\Program Files\Git\bin'],
    separator => ';',
    mergemode => prepend,
  }

  $dev_packages = ['puppet','rake','r10k','ra10ke','puppet-lint','rest-client', 'puppetlabs_spec_helper']
  ensure_packages($dev_packages,{ensure => present,provider => system_gem,require  => Package['Puppet Development Kit']})

# This is a shim so that the buildserver can talk to the local gitlab container
  file { 'C:/Windows/System32/config/systemprofile/.ssh':
    ensure => directory,
    owner  => 'Administrator',
    group  => 'Administrators',
    mode   => '0770',
  }

  file { 'C:/Windows/System32/config/systemprofile/.ssh/config':
    ensure  => present,
    owner   => 'Administrator',
    group   => 'Administrators',
    mode    => '0770',
    source  => 'puppet:///modules/profile/puppet/cd4pe_buildserver/distelli.ssh.config',
    require => File['C:/Windows/System32/config/systemprofile/.ssh'],
  }

  file {'C:/Rakefile':
    ensure => present,
    source => 'puppet:///modules/profile/puppet/cd4pe_buildserver/Rakefile',
  }
}

