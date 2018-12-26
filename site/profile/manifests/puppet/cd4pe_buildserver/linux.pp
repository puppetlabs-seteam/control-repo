# This class installs the necessary components to become a Distelli Buildserver
class profile::puppet::cd4pe_buildserver::linux(
  String $ruby_version = '2.5.3',
) {

  unless $::osfamily == 'RedHat' or $::osfamily == 'Debian' {
    fail("Unsupported OS ${::osfamily}")
  }

  include ::pdk
  include docker
  class { 'rbenv': }
  rbenv::plugin { [ 'rbenv/rbenv-vars', 'rbenv/ruby-build' ]: }
  rbenv::build { $ruby_version: global => true }
  rbenv::gem { 'puppet-lint': ruby_version => $ruby_version }
  rbenv::gem { 'rake': ruby_version => $ruby_version }
  rbenv::gem { 'r10k': ruby_version => $ruby_version }
  rbenv::gem { 'ra10ke': ruby_version => $ruby_version }
  rbenv::gem { 'onceover': ruby_version => $ruby_version }
  rbenv::gem { 'rest-client': ruby_version => $ruby_version }


  # Set this default because there seems to be a bug in puppetlabs/docker 3.0.0
  # that makes it effectively required.
  Docker::Run {
    health_check_interval => 30,
  }

  $dev_packages = $::osfamily ? {
    'RedHat' => ['gcc','gcc-c++','openssl-devel','readline-devel','zlib-devel','cmake'],
    'Debian' => ['build-essential','cmake','libssl-dev','zlib1g-dev','libreadline6-dev'],
  }

  ensure_packages($dev_packages,{ensure => present})

  file { '/etc/profile.d/pdkrubypath.sh':
        mode    => '0644',
        content => 'PATH=$PATH:/opt/puppetlabs/pdk/private/ruby/2.5.1/bin',
  }

  file {'/Rakefile':
    ensure => present,
    mode   => '0755',
    source => 'puppet:///modules/profile/puppet/cd4pe_buildserver/Rakefile',
  }
}
