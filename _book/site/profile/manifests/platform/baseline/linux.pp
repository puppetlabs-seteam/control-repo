class profile::platform::baseline::linux {

  include ::profile::platform::baseline::linux::packages
  include ::profile::platform::baseline::linux::vim
  include ::profile::platform::baseline::linux::motd
  include ::profile::platform::baseline::users::linux
  include ::profile::platform::baseline::linux::ssh
  include ::profile::platform::baseline::linux::firewall

}
