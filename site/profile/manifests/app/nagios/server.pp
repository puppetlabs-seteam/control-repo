class profile::app::nagios::server {

  if $facts['os']['family'] != 'redhat' {
    fail('This class is only for EL family')
  }

  require epel
  require apache
  require apache::mod::ssl
  require apache::mod::php

  class { 'selinux':
    mode => 'permissive',
    type => 'targeted',
  }

  package { ['nagios','nagios-plugins','nagios-plugins-all']:
    ensure  => present,
  }

  file { '/etc/nagios/conf.d':
    ensure  => directory,
    owner   => 'nagios',
    group   => 'nagios',
    mode    => '0755',
    require => Package['nagios'],
  }

  # apache config for nagios
  file { '/etc/httpd/conf.d/nagios.conf':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('profile/nagios.conf.erb'),
    require => Package['nagios'],
  }

  file_line { 'nagios_host':
    path   => '/etc/nagios/nagios.cfg',
    line   => 'cfg_file=/etc/nagios/nagios_host.cfg',
    notify => Service['nagios'],
  }

  file_line { 'nagios_service':
    path   => '/etc/nagios/nagios.cfg',
    line   => 'cfg_file=/etc/nagios/nagios_service.cfg',
    notify => Service['nagios'],
  }

  file { '/etc/nagios/nagios_host.cfg':
    ensure => 'file',
    mode   => '0644',
  }

  file { '/etc/nagios/nagios_service.cfg':
    ensure => 'file',
    mode   => '0644',
  }

  service { 'nagios':
    ensure    => running,
    enable    => true,
    subscribe => File['/etc/httpd/conf.d/nagios.conf'],
  }

  @@host { $::fqdn:
    ip => $::ipaddress,
  }

  Host <<||>>
  Nagios_host <<||>> {
    notify => Service['nagios','httpd'],
  }
  Nagios_service <<||>> {
    notify => Service['nagios','httpd'],
  }

}
