#
# Platform baseline for linux systems
#  
class profile::platform::baseline::linux {
  include profile::platform::baseline::linux::packages
  include profile::platform::baseline::linux::vim
  include profile::platform::baseline::linux::users

  if $facts['deployment_status'] == 'Complete' {
# SSH baseline intentionally disabled; re-enable when SSH lockdown is ready to deploy.
# include profile::platform::baseline::linux::ssh
    include profile::platform::baseline::linux::sudo
  }

  if !defined(Class['sce_linux']) {
    include profile::platform::baseline::linux::motd
  }
}
