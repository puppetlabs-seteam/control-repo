class profile::puppet::seteam_master {

  if $::facts['kernel'] != 'Linux' {
    fail('Unsupported OS!')
  }

  include ::profile::puppet::master::gitea
  include ::profile::puppet::master::autosign
  include ::profile::puppet::master::fileserver
  include ::profile::puppet::master::firewall
  include ::profile::puppet::master::hiera
  include ::profile::puppet::master::node_manager

}
