class role::seteam_puppet_master {
  include profile::platform::baseline
  include profile::puppet::seteam_master
}
