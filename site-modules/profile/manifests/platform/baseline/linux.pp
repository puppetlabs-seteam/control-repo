#
# Platform baseline for linux systems
#  
class profile::platform::baseline::linux {
  include profile::platform::baseline::linux::packages
  include profile::platform::baseline::linux::vim
  include profile::platform::baseline::linux::users
  include profile::platform::baseline::linux::ssh
  include profile::platform::baseline::linux::sudo

  if !defined(Class['Cem_linux']) {
    include profile::platform::baseline::linux::motd
  }
}
