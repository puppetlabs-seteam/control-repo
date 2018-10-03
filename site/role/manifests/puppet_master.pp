class role::puppet_master {
  include profile::platform::baseline
  include profile::puppet::master::firewall
}
