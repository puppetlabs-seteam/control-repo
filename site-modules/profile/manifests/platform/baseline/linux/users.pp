# @summary 
# Define default users on linux systems
#
# @param password
# Default password for puppet user accounts.
# @param puppetadmin_password
class profile::platform::baseline::linux::users (
  String $password, # This should be a password hash for use in /etc/shadow.
  String $puppetadmin_password,
) {
  user { 'puppetadmin':
    ensure   => 'present',
    comment  => 'Admin User Account',
    home     => '/home/puppetadmin',
    groups   => ['puppetadmin'],
    password => $puppetadmin_password,
    shell    => '/bin/bash',
    require  => Group['puppetadmin'],
  }
  group { 'puppetadmin':
    ensure => present,
  }
  file { '/home/puppetadmin':
    ensure => directory,
    owner  => puppetadmin,
    group  => puppetadmin,
    mode   => '0700',
  }
  user { 'PuppetSE':
    ensure   => 'present',
    comment  => 'SE Demo Account',
    gid      => '100',
    home     => '/',
    password => $password,
    shell    => '/bin/bash',
    uid      => '1010',
  }
}
