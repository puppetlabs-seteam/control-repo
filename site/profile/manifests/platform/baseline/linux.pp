class profile::platform::baseline::linux {

  include ::profile::platform::baseline::general::linux::packages
  include ::profile::platform::baseline::general::linux::vim
  include ::profile::platform::baseline::general::linux::motd
  include ::profile::platform::baseline::users::linux
  include ::profile::platform::baseline::general::linux::ssh
  include ::profile::platform::baseline::general::linux::firewall

}
