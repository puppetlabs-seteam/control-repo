class role::puppetmaster {
  include ::profile::platform::baseline
  include ::profile::puppet::master
}
